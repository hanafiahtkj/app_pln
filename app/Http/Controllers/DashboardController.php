<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Cache;
use Inertia\Inertia;
use App\Models\Prk;
use App\Models\Paket;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();

        // Ambil tahun dari request (default null)
        $tahunFilter = $request->query('tahun');

        $query = Prk::with([
            'unit',
            'bidang',
            'pakets.enjiniring.rendan.lakdan.kontrak.purchase_order',
            'pakets.enjiniring.rendan.lakdan.kontrak.pembayaran'
        ])
        ->when($tahunFilter, function ($q) use ($tahunFilter) {
            $q->where('tahun', $tahunFilter); // Memfilter kolom tahun di tabel PRK
        })
        ->latest();

        if (!$user->hasRole('superuser') && $user->unit_id != 1) {
            $query->where('unit_id', $user->unit_id);
        }

        // withQueryString() memastikan filter tahun tetap terbawa saat pindah halaman (paging)
        $prks = $query->paginate(10)->withQueryString();

        $prks->getCollection()->transform(function ($prk) {
            $prk->pakets->transform(function ($paket) {
                $kontrak = $paket->enjiniring?->rendan?->lakdan?->kontrak;

                // Hitung jumlah dari semua record pembayaran
                $totalBayar = $kontrak?->pembayaran->sum('nilai_bayar_vendor') ?? 0;

                // Ambil nilai perjanjian
                $nilaiPerjanjian = $kontrak?->nilai_perjanjian_ppn ?? 0;

                // Tempelkan data ke objek paket
                $paket->total_terbayar = $totalBayar;
                $paket->nilai_perjanjian = $nilaiPerjanjian;

                return $paket;
            });
            return $prk;
        });

        // Statistik / Grafik
        $query = Paket::with(['prk', 'enjiniring.rendan.lakdan.kontrak.pembayaran'])
            ->when($tahunFilter, function($q) use ($tahunFilter) {
                $q->where('tahun', $tahunFilter);
            });

        if (!$user->hasRole('superuser') && $user->unit_id != 1) {
            $query->whereHas('prk', function($q) use ($user) {
                $q->where('unit_id', $user->unit_id);
            });
        }

        $allPakets = $query->get();

        // 1. Akumulasi Paket
        $totalPaket = $allPakets->count();
        $totalTerkontrak = $allPakets->filter(fn($p) => $p->enjiniring?->rendan?->lakdan?->kontrak)->count();

        // 2. Akumulasi Keuangan
        $totalRencanaBayar = $allPakets->sum(fn($p) => $p->enjiniring?->rendan?->lakdan?->kontrak?->nilai_perjanjian_ppn ?? 0);
        $totalRealisasiBayar = $allPakets->sum(function($p) {
            return $p->enjiniring?->rendan?->lakdan?->kontrak?->pembayaran->sum('nilai_bayar_vendor') ?? 0;
        });

        return Inertia::render('Dashboard', [
            'prks'   => $prks,
            'stats'  => $this->getStats(),
            'totalStats' => [
                'paket' => [
                    'total' => $totalPaket,
                    'terkontrak' => $totalTerkontrak
                ],
                'keuangan' => [
                    'rencana' => $totalRencanaBayar,
                    'realisasi' => $totalRealisasiBayar
                ]
            ],
            'filters'=> $request->only(['tahun']) // Kirim balik nilai filter ke Vue
        ]);
    }

    public function getStats()
    {
        return Cache::remember('dashboard_stats', 60, function () {
            $totalMembers = User::count();
            $newMembersToday = User::whereDate('created_at', today())->count();
            $memberGrowth = $this->calculateGrowthPercentage(
                User::whereDate('created_at', '>=', now()->subDays(7))->count(),
                User::whereDate('created_at', '>=', now()->subDays(14))->whereDate('created_at', '<', now()->subDays(7))->count()
            );

            return [
                [
                    'title'  => 'Total Members',
                    'value'  => number_format($totalMembers),
                    'growth' => sprintf('%+.1f%%', $memberGrowth),
                ],
                [
                    'title'  => 'New Members Today',
                    'value'  => number_format($newMembersToday),
                    'growth' => sprintf('%+.1f%%', $newMembersToday > 0 ? 100 : 0),
                ],
                [
                    'title'  => 'Weekly Growth',
                    'value'  => sprintf('%+.1f%%', $memberGrowth),
                    'growth' => sprintf('%+.1f%%', $memberGrowth),
                ],
                [
                    'title'  => 'Total Sessions',
                    'value'  => number_format(rand(5000, 15000)),
                    'growth' => sprintf('%+.1f%%', rand(5, 15)),
                ],
            ];
        });
    }

    private function calculateGrowthPercentage($current, $previous)
    {
        if ($previous == 0) {
            return $current > 0 ? 100 : 0;
        }

        return (($current - $previous) / $previous) * 100;
    }
}
