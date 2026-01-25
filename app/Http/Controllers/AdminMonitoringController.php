<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Cache;
use Inertia\Inertia;
use App\Models\Prk;
use App\Models\Paket;
use App\Models\Unit;
use Illuminate\Http\Request;
use App\Services\DataTablePaginationService;

class AdminMonitoringController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        // $this->middleware('permission:manage-monitoring');
    }

    /**
     * Tampilkan daftar data Pembayaran.
     */
    public function index(Request $request)
    {
        $user = auth()->user();

        // Ambil tahun dari request (default null)
        $tahunFilter = $request->query('tahun') ?? date('Y');
        $unitFilter = $request->query('unit_id');
        $canFilterUnit = $user->hasRole('superuser') || $user->unit_id == 1;
        $perPage = $request->query('per_page', 10);

        // $query = Prk::with([
        //     'unit',
        //     'bidang',
        //     'pakets' => function ($q) use ($user, $canFilterUnit, $unitFilter) {
        //         if ($canFilterUnit) {
        //             if ($unitFilter) {
        //                 $q->where('unit_id', $unitFilter);
        //             }
        //         } else {
        //             $q->where('unit_id', $user->unit_id);
        //         }
        //     },
        //     'pakets.unit',
        //     'pakets.enjiniring.rendan.lakdan.kontrak.purchase_order',
        //     'pakets.enjiniring.rendan.lakdan.kontrak.pembayaran'
        // ])
        // ->when($tahunFilter, function ($q) use ($tahunFilter) {
        //     if ($tahunFilter !== 'semua') {
        //         $q->where('tahun', $tahunFilter);
        //     }
        // })
        // ->latest();

        $query = Paket::latest()->with([
            'unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ]);

        if ($tahunFilter !== 'semua') {
            $query->where('tahun', $tahunFilter);
        }

        if ($canFilterUnit) {
            if ($unitFilter) {
                $query->where('unit_id', $unitFilter);
            }
        } else {
            $query->where('unit_id', $user->unit_id);
        }

        $pakets = $query->paginate($perPage)->withQueryString();

        // Perbaiki Transform: Sekarang kita langsung memproses objek Paket
        $pakets->getCollection()->transform(function ($paket) {
            // Akses kontrak melalui nesting relasi
            $kontrak = $paket->enjiniring?->rendan?->lakdan?->kontrak;

            $totalBayarVendor = 0;
            $totalBayarPajak = 0;

            if ($kontrak && $kontrak->pembayaran) {
                // Gunakan collection methods (where & sum) dari hasil eager loading
                $totalBayarVendor = $kontrak->pembayaran
                    ->where('lunas_vendor', true)
                    ->sum('nilai_bayar_vendor');

                $totalBayarPajak = $kontrak->pembayaran
                    ->where('lunas_pajak', true)
                    ->sum('nilai_bayar_pajak');
            }

            // Tambahkan atribut custom ke objek paket
            $paket->total_terbayar = $totalBayarVendor + $totalBayarPajak;
            $paket->nilai_perjanjian = $kontrak?->nilai_perjanjian_ppn ?? 0;

            return $paket;
        });

        // Statistik / Grafik
        $unitStats = Unit::with(['pakets' => function($q) use ($tahunFilter) {
            $q->when($tahunFilter, function($query) use ($tahunFilter) {
                if ($tahunFilter !== 'semua') {
                    $query->where('tahun', $tahunFilter);
                }
            })->with(['enjiniring.rendan.lakdan.kontrak.pembayaran']);
        }])->get()->map(function($unit) {
            $pakets = $unit->pakets;

            // Hitung per unit
            $totalPaket = $pakets->count();
            $totalTerkontrak = $pakets->filter(fn($p) => $p->enjiniring?->rendan?->lakdan?->kontrak)->count();

            $rencana = $pakets->sum(fn($p) => $p->enjiniring?->rendan?->lakdan?->kontrak?->nilai_perjanjian_ppn ?? 0);

            // Nilai Realisasi (Total Pembayaran yang sudah Lunas)
            $realisasi = $pakets->sum(function($p) {
                $kontrak = $p->enjiniring?->rendan?->lakdan?->kontrak;

                if (!$kontrak || !$kontrak->pembayaran) {
                    return 0;
                }

                // Hanya jumlahkan vendor yang lunas + pajak yang lunas
                $bayarVendor = $kontrak->pembayaran->where('lunas_vendor', true)->sum('nilai_bayar_vendor');
                $bayarPajak = $kontrak->pembayaran->where('lunas_pajak', true)->sum('nilai_bayar_pajak');

                return $bayarVendor + $bayarPajak;
            });

            return [
                'unit_name' => $unit->name,
                'total' => $totalPaket,
                'terkontrak' => $totalTerkontrak,
                'rencana' => $rencana,
                'realisasi' => $realisasi,
            ];
        });

        // Hitung total akumulasi nasional untuk Card
        $totalRencanaAll = $unitStats->sum('rencana');
        $totalRealisasiAll = $unitStats->sum('realisasi');

        return Inertia::render('IndexMonitoring', [
            'units' => Unit::all(),
            'pakets'   => $pakets,
            'unitStats' => $unitStats,
            'totalStats' => [
                'paket' => [
                    'total' => $unitStats->sum('total'),
                    'terkontrak' => $unitStats->sum('terkontrak')
                ],
                'keuangan' => [
                    'rencana' => $totalRencanaAll,
                    'realisasi' => $totalRealisasiAll,
                    // Tambahkan persentase serapan
                    'persen_serapan' => $totalRencanaAll > 0 ? round(($totalRealisasiAll / $totalRencanaAll) * 100, 1) : 0
                ]
            ],
            'filters' => [
                'tahun' => $tahunFilter,
                'unit_id' => $unitFilter,
                'per_page' => $perPage,
            ]
        ]);
    }
}
