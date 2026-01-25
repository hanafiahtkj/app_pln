<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use App\Models\Kontrak; // Model untuk relasi (Foreign Key)
use App\Models\Pembayaran; // Model utama (Pembayaran)
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Exception;
use App\Services\DataTablePaginationService;

class AdminMonitoringPaketController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-monitoring');
    }


    /**
     * Tampilkan daftar data Pembayaran.
     */
    public function index(Request $request)
    {
        $perPage = $this->pagination->resolvePerPageWithDefaults($request);

        $tahunFilter = $request->query('tahun') ?? date('Y');
        $statusFilter = $request->input('filter_status', 'semua');

        $query = Paket::latest()->with([
            'unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ]);

        $user = auth()->user();

        // Filter berdasarkan unit user
        if (!$user->hasRole('superuser') && $user->unit_id != 1) {
            $query->where('unit_id', $user->unit_id);
        }

        if ($tahunFilter !== 'semua') {
            $query->where('tahun', $tahunFilter);
        }

        $data = $query->paginate($perPage)->withQueryString();

        return Inertia::render('Admin/Monitoring/IndexPage', [
            'data' => $data,
            'filters' => [
                'status' => $statusFilter,
                'tahun' => $tahunFilter,
            ]
        ]);
    }

    public function show($id)
    {
        $paket = Paket::with([
            'unit',
            'prk.unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ])->findOrFail($id);

        return Inertia::render('Admin/Monitoring/ShowPage', [
            'data' => $paket,
        ]);
    }
}
