<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use App\Models\Lakdan; // Model untuk relasi (Foreign Key)
use App\Models\Kontrak; // Model utama (Kontrak)
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Exception;
use App\Services\DataTablePaginationService;

class AdminKontrakController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-kontrak');
    }

    /**
     * Tampilkan daftar data Kontrak.
     */
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
       if (!$user->hasRole('superuser') && $user->unit_id != 1) {
            $query->whereHas('prk', function ($q) use ($user) {
                $q->where('unit_id', $user->unit_id);
            });
        }

        // LOGIKA FILTER BARU
        if ($statusFilter === 'belum_diproses') {
            $query->has('enjiniring.rendan.lakdan');
            $query->whereDoesntHave('enjiniring.rendan.lakdan.kontrak');
        } elseif ($statusFilter === 'proses') {
            $query->has('enjiniring.rendan.lakdan.kontrak');
        }

        $data = $query->paginate($perPage)->withQueryString();

        return Inertia::render('Admin/Kontrak/IndexPage', [
            'data' => $data,
            'filters' => [
                'status' => $statusFilter
            ]
        ]);
    }

    /**
     * Tampilkan form untuk membuat Kontrak baru.
     */
    public function create()
    {
        $lakdans = Lakdan::with('rendan.enjiniring.paket.prk')
            ->doesntHave('kontrak')
            ->get();

        return Inertia::render('Admin/Kontrak/CreatePage', [
            'lakdans' => $lakdans,
        ]);
    }

    /**
     * Tampilkan form untuk mengedit Kontrak.
     */
    public function edit($id)
    {
        $kontrak = Kontrak::findOrFail($id);

        $currentLakdanId = $kontrak->lakdan_id;

        $lakdans = Lakdan::with('rendan.enjiniring.paket.prk')
            ->where(function ($query) use ($currentLakdanId) {
                $query->doesntHave('kontrak');
                $query->orWhere('id', $currentLakdanId);
            })
            ->get();

        return Inertia::render('Admin/Kontrak/EditPage', [
            'data' => $kontrak,
            'lakdans' => $lakdans,
        ]);
    }

    // --- STORE METHOD (Tambah Data) ---
    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'lakdan_id' => ['required', 'exists:lakdans,id'],

            // Core Kontrak Fields
            'penyedia_barang_jasa' => ['required', 'string', 'max:255'],
            'jenis_perjanjian' => ['required', 'string', 'max:50'],
            'status_proses' => ['required', 'string', 'max:50'],
            'keterangan' => ['nullable', 'string'],
            'masa_pelaksanaan' => ['required', 'integer', 'min:0'],
            'durasi_pengadaan' => ['required', 'integer', 'min:0'],

            // Date & Numeric Fields
            'rencana_tanggal_perjanjian' => ['nullable', 'date'],
            'realisasi_tanggal_perjanjian' => ['nullable', 'date'],
            'tanggal_berakhir' => ['nullable', 'date'],
            'nomor_perjanjian' => ['required', 'string', 'max:255'],
            'nilai_perjanjian_ppn' => ['nullable', 'numeric'],
            'nilai_perjanjian_sebelum_ppn' => ['nullable', 'numeric'],

            // Jaminan Pelaksanaan Fields
            'rencana_jaminan_pelaksanaan' => ['nullable', 'date'],
            'realisasi_jaminan_pelaksanaan' => ['nullable', 'date'],
            'nomor_jaminan_pelaksanaan' => ['nullable', 'string', 'max:255'],
            'nilai_jaminan_pelaksanaan' => ['nullable', 'numeric'],
            'bank_pemberi_jaminan' => ['nullable', 'string', 'max:100'],

            // Metric Fields
            'tingkat_risiko_csms' => ['nullable', 'string', 'max:50'],
            'tkdn' => ['nullable', 'numeric'],
            'efisiensi_thd_hps' => ['nullable', 'string', 'max:50'],

            // Document Fields
            'dokumen_perjanjian' => ['nullable', 'string'],
            'dokumen_jaminan_pelaksanaan' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $kontrakData = $validated;

            $req = Kontrak::create($kontrakData);

            DB::commit();

            return redirect()
                ->route('admin.kontrak.show', $req->lakdan->rendan->enjiniring->paket->id)
                ->with('success', 'Data Kontrak berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();

            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Kontrak: ' . $e->getMessage());
        }
    }

    // --- UPDATE METHOD (Edit Data) ---
    public function update(Request $request, $id)
    {
        $kontrak = Kontrak::findOrFail($id);

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'lakdan_id' => ['required', 'exists:lakdans,id'],

            // Core Kontrak Fields
            'penyedia_barang_jasa' => ['required', 'string', 'max:255'],
            'jenis_perjanjian' => ['required', 'string', 'max:50'],
            'status_proses' => ['required', 'string', 'max:50'],
            'keterangan' => ['nullable', 'string'],
            'masa_pelaksanaan' => ['required', 'integer', 'min:0'],
            'durasi_pengadaan' => ['required', 'integer', 'min:0'],

            // Date & Numeric Fields
            'rencana_tanggal_perjanjian' => ['nullable', 'date'],
            'realisasi_tanggal_perjanjian' => ['nullable', 'date'],
            'tanggal_berakhir' => ['nullable', 'date'],
            'nomor_perjanjian' => ['required', 'string', 'max:255', Rule::unique('kontraks')->ignore($kontrak->id)], // Unique ignore current
            'nilai_perjanjian_ppn' => ['nullable', 'numeric'],
            'nilai_perjanjian_sebelum_ppn' => ['nullable', 'numeric'],

            // Jaminan Pelaksanaan Fields
            'rencana_jaminan_pelaksanaan' => ['nullable', 'date'],
            'realisasi_jaminan_pelaksanaan' => ['nullable', 'date'],
            'nomor_jaminan_pelaksanaan' => ['nullable', 'string', 'max:255'],
            'nilai_jaminan_pelaksanaan' => ['nullable', 'numeric'],
            'bank_pemberi_jaminan' => ['nullable', 'string', 'max:100'],

            // Metric Fields
            'tingkat_risiko_csms' => ['nullable', 'string', 'max:50'],
            'tkdn' => ['nullable', 'numeric'],
            'efisiensi_thd_hps' => ['nullable', 'string', 'max:50'],

            // Document Fields (Hanya perlu path/name jika ada upload baru)
            'dokumen_perjanjian' => ['nullable', 'string'],
            'dokumen_jaminan_pelaksanaan' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $kontrakData = $validated;

            $kontrak->update($kontrakData);

            DB::commit();

            return redirect()
                ->route('admin.kontrak.show', $kontrak->lakdan->rendan->enjiniring->paket->id)
                ->with('success', 'Data Kontrak berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();

            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Kontrak: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Kontrak::findOrFail($id);

            $data->delete();
            DB::commit();

            return redirect()
                ->route('admin.kontrak.index')
                ->with('success', 'Data Kontrak dan file terkait berhasil dihapus.');
        } catch (Exception $e) {
            DB::rollBack();
            return redirect()
                ->route('admin.kontrak.index')
                ->with('error', 'Gagal menghapus Kontrak: ' . $e->getMessage());
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

        return Inertia::render('Admin/Kontrak/ShowPage', [
            'data' => $paket,
        ]);
    }
}
