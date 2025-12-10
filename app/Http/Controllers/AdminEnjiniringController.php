<?php

namespace App\Http\Controllers;

use App\Models\Prk;
use App\Models\Paket;
use App\Models\Enjiniring;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;

// Controller untuk mengelola data Paket Enjiniring (Tanpa File Upload)
class AdminEnjiniringController extends Controller
{
    public function __construct()
    {
        // $this->middleware('permission:manage-paket-enjiniring');
    }

    /**
     * Menampilkan daftar data Paket Enjiniring.
     */
    public function index(Request $request)
    {
        $data = Enjiniring::latest()
            ->with('prk.pakets')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Enjiniring/IndexPage', [
            'data' => $data,
        ]);
    }

    private function getAvailablePrks()
    {
        // 1. Filter: Hanya ambil ID PRK yang sudah memiliki Paket
        $prkIdsWithPaket = Paket::pluck('prk_id')->unique();

        // 2. Query: Ambil data PRK berdasarkan ID yang sudah terfilter
        return Prk::whereIn('id', $prkIdsWithPaket)
            ->select('id', 'prk')
            ->get();
    }

    /**
     * Menampilkan form untuk membuat data Paket Enjiniring baru.
     */
    public function create()
    {
        return Inertia::render('Admin/Enjiniring/CreatePage', [
            'prks' => $this->getAvailablePrks(),
        ]);
    }

    /**
     * Menyimpan data Paket Enjiniring baru ke database.
     */
    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi (hanya untuk data non-file)
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'],
            'target_survey' => ['nullable', 'date'],
            'realisasi_survey' => ['nullable', 'date'],
            'target_dokumen_enjiniring' => ['nullable', 'date'],
            'realisasi_dokumen_enjiniring' => ['nullable', 'date'],
            'keterangan' => ['nullable', 'string'],

            // Field dokumen hanya dipertahankan sebagai string/text biasa
            'dokumen_survey' => ['nullable', 'string', 'max:255'],
            'dokumen_rab' => ['nullable', 'string', 'max:255'],
            'dokumen_tor' => ['nullable', 'string', 'max:255'],
        ]);

        try {
            DB::beginTransaction();

            // 2. Simpan data Paket Enjiniring ke database
            Enjiniring::create($validated);

            DB::commit();

            return redirect()
                ->route('admin.enjiniring.index')
                ->with('success', 'Data Paket Enjiniring berhasil ditambahkan.');

        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Paket Enjiniring: ' . $e->getMessage());
        }
    }

    /**
     * Menampilkan form edit data Paket Enjiniring.
     */
    public function edit($id)
    {
        // Eager load relasi 'prk'
        $paketEnjiniring = Enjiniring::with('prk')->findOrFail($id);

        // prk_id sudah tersedia di objek $paketEnjiniring

        return Inertia::render('Admin/Enjiniring/EditPage', [
            'data' => $paketEnjiniring,
            'prks' => $this->getAvailablePrks(),
        ]);
    }

    /**
     * Memperbarui data Paket Enjiniring di database.
     */
    public function update(Request $request, $id)
    {
        $paketEnjiniring = Enjiniring::findOrFail($id);

        // 1. Tentukan aturan validasi (hanya untuk data non-file)
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'],
            'target_survey' => ['nullable', 'date'],
            'realisasi_survey' => ['nullable', 'date'],
            'target_dokumen_enjiniring' => ['nullable', 'date'],
            'realisasi_dokumen_enjiniring' => ['nullable', 'date'],
            'keterangan' => ['nullable', 'string'],

            // Field dokumen hanya dipertahankan sebagai string/text biasa
            'dokumen_survey' => ['nullable', 'string', 'max:255'],
            'dokumen_rab' => ['nullable', 'string', 'max:255'],
            'dokumen_tor' => ['nullable', 'string', 'max:255'],
        ]);

        try {
            DB::beginTransaction();

            // 2. Update data Paket Enjiniring
            $paketEnjiniring->update($validated);

            DB::commit();

            return redirect()
                ->route('admin.enjiniring.index')
                ->with('success', 'Data Paket Enjiniring berhasil diperbarui.');

        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Paket Enjiniring: ' . $e->getMessage());
        }
    }

    /**
     * Menghapus data Paket Enjiniring.
     */
    public function destroy($id)
    {
        try {
            $data = Enjiniring::findOrFail($id);
            $data->delete();

            return redirect()
                ->route('admin.enjiniring.index')
                ->with('success', 'Data Paket Enjiniring berhasil dihapus.');
        } catch (\Exception $e) {
            return redirect()
                ->route('admin.enjiniring.index')
                ->with('error', 'Gagal menghapus Paket Enjiniring: ' . $e->getMessage());
        }
    }
}
