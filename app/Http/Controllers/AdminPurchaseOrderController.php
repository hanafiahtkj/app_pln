<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use App\Models\Kontrak;
use App\Models\PurchaseOrder;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Exception;
use App\Services\DataTablePaginationService;

class AdminPurchaseOrderController extends Controller
{
    /**
     * Daftar kolom dokumen yang disimpan di DB.
     */
    private array $documentFields = [
        'dokumen_po',
        'dokumen_pemeriksaan_mos',
        'ba_pemeriksaan_25',
        'ba_pemeriksaan_50',
        'ba_pemeriksaan_75',
        'ba_pembayaran_25',
        'ba_pembayaran_50',
        'ba_pembayaran_75',
        'ba_stp',
        'ba_stap',
    ];

    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-konstruksi');
    }

    /**
     * Aturan validasi yang disederhanakan.
     */
    private function getValidationRules(): array
    {
        $rules = [
            'kontrak_id' => ['required', 'exists:kontraks,id'],

            // --- Date Fields ---
            'rencana_po'          => ['nullable', 'date'],
            'realisasi_po'        => ['nullable', 'date'],
            'rencana_mos'         => ['nullable', 'date'],
            'realisasi_mos'       => ['nullable', 'date'],
            'rencana_progress_25' => ['nullable', 'date'],
            'realisasi_progress_25' => ['nullable', 'date'],
            'rencana_progress_50' => ['nullable', 'date'],
            'realisasi_progress_50' => ['nullable', 'date'],
            'rencana_progress_75' => ['nullable', 'date'],
            'realisasi_progress_75' => ['nullable', 'date'],
            'rencana_cod'         => ['nullable', 'date'],
            'realisasi_cod'       => ['nullable', 'date'],

            'keterangan'          => ['nullable', 'string'],
        ];

        // Karena FileManagerInput mengirim string URL, validasinya cukup string nullable
        foreach ($this->documentFields as $field) {
            $rules[$field] = ['nullable', 'string'];
        }

        return $rules;
    }

    public function index(Request $request)
    {
        $perPage = $this->pagination->resolvePerPageWithDefaults($request);

        // Ambil status filter dari request, default-kan ke 'belum_diproses' jika tidak ada filter lain
        $statusFilter = $request->input('filter_status', 'belum_diproses');

        $query = Paket::latest()->with([
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ]);

        $user = auth()->user();

        // Filter berdasarkan unit user
        if ($user->hasRole('user')) {
            $query->whereHas('prk', function ($q) use ($user) {
                $q->where('unit_id', $user->unit_id);
            });
        }

        // LOGIKA FILTER BARU
        if ($statusFilter === 'belum_diproses') {
            $query->has('enjiniring.rendan.lakdan.kontrak');
            $query->whereDoesntHave('enjiniring.rendan.lakdan.kontrak.purchase_order');
        } elseif ($statusFilter === 'proses') {
            $query->has('enjiniring.rendan.lakdan.kontrak.purchase_order');
        }

        $data = $query->paginate($perPage)->withQueryString();

        return Inertia::render('Admin/PurchaseOrder/IndexPage', [
            'data' => $data,
            'filters' => [
                'status' => $statusFilter
            ]
        ]);
    }

    public function create()
    {
        $kontraks = Kontrak::with('lakdan.rendan.enjiniring.paket.prk')
            ->doesntHave('purchase_order')
            ->get();

        return Inertia::render('Admin/PurchaseOrder/CreatePage', [
            'kontraks' => $kontraks,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate($this->getValidationRules());

        try {
            // Langsung simpan karena $validated sudah berisi path string dari File Manager
            $req = PurchaseOrder::create($validated);

            return redirect()
                ->route('admin.po.show', $req->kontrak->lakdan->rendan->enjiniring->paket->id)
                ->with('success', 'Data Purchase Order berhasil disimpan.');

        } catch (Exception $e) {
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data: ' . $e->getMessage());
        }
    }

    public function edit($id)
    {
        $po = PurchaseOrder::findOrFail($id);
        $currentKontrakId = $po->kontrak_id;

        $kontraks = Kontrak::with('lakdan.rendan.enjiniring.paket.prk')
            ->where(function ($query) use ($currentKontrakId) {
                $query->doesntHave('purchase_order')
                      ->orWhere('id', $currentKontrakId);
            })
            ->get();

        return Inertia::render('Admin/PurchaseOrder/EditPage', [
            'data' => $po,
            'kontraks' => $kontraks,
        ]);
    }

    public function update(Request $request, $id)
    {
        $po = PurchaseOrder::findOrFail($id);
        $validated = $request->validate($this->getValidationRules());

        try {
            // Update langsung dengan path baru yang dikirim dari Vue
            $po->update($validated);

            return redirect()
                ->route('admin.po.show', $po->kontrak->lakdan->rendan->enjiniring->paket->id)
                ->with('success', 'Data Purchase Order berhasil diperbarui.');

        } catch (Exception $e) {
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data: ' . $e->getMessage());
        }
    }

    public function destroy($id)
    {
        try {
            $data = PurchaseOrder::findOrFail($id);

            $data->delete();

            return redirect()
                ->route('admin.po.index')
                ->with('success', 'Data Purchase Order berhasil dihapus.');
        } catch (Exception $e) {
            return redirect()->back()->with('error', 'Gagal menghapus data.');
        }
    }

    public function show($id)
    {
        $paket = Paket::with([
            'prk.unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ])->findOrFail($id);

        return Inertia::render('Admin/PurchaseOrder/ShowPage', [
            'data' => $paket,
        ]);
    }
}
