<?php

namespace App\Http\Controllers;

use App\Models\Kontrak; // Model untuk relasi (Foreign Key)
use App\Models\Pembayaran; // Model utama (Pembayaran)
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Exception;

class AdminPembayaranController extends Controller
{
    /**
     * Menghasilkan aturan validasi yang dapat digunakan kembali untuk Pembayaran.
     */
    private function getValidationRules($id = null): array
    {
        $rules = [
            'kontrak_id' => ['required', 'exists:kontraks,id'],

            // --- Detail Pembayaran ---
            'termin_pembayaran' => ['required', 'string', 'max:255'],
            'denda' => ['nullable', 'numeric', 'min:0'],

            // --- Nilai (Decimal Fields) ---
            'nilai_tagihan' => ['nullable', 'numeric', 'min:0'],
            'nilai_akb' => ['nullable', 'numeric', 'min:0'],
            'nilai_ppn' => ['nullable', 'numeric', 'min:0'],
            'nilai_pph' => ['nullable', 'numeric', 'min:0'],
            'nilai_bayar_vendor' => ['nullable', 'numeric', 'min:0'],
            'nilai_bayar_pajak' => ['nullable', 'numeric', 'min:0'],

            // --- Tanggal Pembayaran Vendor ---
            'rencana_bayar' => ['nullable', 'date'],
            'realisasi_bayar' => ['nullable', 'date'],

            // --- Tanggal Pembayaran Pajak ---
            'rencana_bayar_pajak' => ['nullable', 'date'],
            'realisasi_bayar_pajak' => ['nullable', 'date'],

            // --- Status Checklist (Boolean/String) ---
            'sub_id' => ['nullable', 'string', 'max:255'],
            'berkas' => ['nullable', 'boolean'],
            'vendor_upload_vip' => ['nullable', 'boolean'],
            'maker' => ['nullable', 'boolean'],
            'checker' => ['nullable', 'boolean'],
            'tax' => ['nullable', 'boolean'],
            'sptjp' => ['nullable', 'boolean'],
            'ira_irs' => ['nullable', 'boolean'],
            'verifikator_pusat' => ['nullable', 'boolean'],
            'lunas_vendor' => ['nullable', 'boolean'],
            'lunas_pajak' => ['nullable', 'boolean'],

            // --- Keterangan ---
            'keterangan' => ['nullable', 'string'],
        ];

        return $rules;
    }

    // Catatan: Semua fungsi handleDocumentUploads, documentFields, dan logika Storage:: telah dihapus

    /**
     * Tampilkan daftar data Pembayaran.
     */
    public function index(Request $request)
    {
        // Eager load relasi kontrak
        $data = Pembayaran::latest()
            ->with('kontrak')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Pembayaran/IndexPage', [
            'data' => $data,
        ]);
    }

    /**
     * Tampilkan form untuk membuat Pembayaran baru.
     */
    public function create()
    {
        // Menyediakan daftar Kontrak untuk dipilih sebagai foreign key
        $kontraks = Kontrak::select('id', 'nomor_perjanjian')->get();

        return Inertia::render('Admin/Pembayaran/CreatePage', [
            'kontraks' => $kontraks,
        ]);
    }

    /**
     * Tampilkan form untuk mengedit Pembayaran.
     */
    public function edit($id)
    {
        $pembayaran = Pembayaran::findOrFail($id);
        $kontraks = Kontrak::select('id', 'nomor_perjanjian')->get();

        return Inertia::render('Admin/Pembayaran/EditPage', [
            'data' => $pembayaran,
            'kontraks' => $kontraks,
        ]);
    }

    // --- STORE METHOD (Tambah Data) ---
    public function store(Request $request)
    {
        $validated = $request->validate($this->getValidationRules());

        try {
            DB::beginTransaction();

            // 1. Simpan data Pembayaran ke database
            Pembayaran::create($validated);

            DB::commit();

            return redirect()
                ->route('admin.pembayaran.index')
                ->with('success', 'Data Pembayaran berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Pembayaran: ' . $e->getMessage());
        }
    }

    // --- UPDATE METHOD (Edit Data) ---
    public function update(Request $request, $id)
    {
        $pembayaran = Pembayaran::findOrFail($id);

        $validated = $request->validate($this->getValidationRules($id));

        try {
            DB::beginTransaction();

            // 1. Update data Pembayaran
            $pembayaran->update($validated);

            DB::commit();

            return redirect()
                ->route('admin.pembayaran.index')
                ->with('success', 'Data Pembayaran berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Pembayaran: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Pembayaran::findOrFail($id);

            // Tidak ada file yang perlu dihapus (karena hanya checklist status)

            $data->delete();
            DB::commit();

            return redirect()
                ->route('admin.pembayaran.index')
                ->with('success', 'Data Pembayaran berhasil dihapus.');
        } catch (Exception $e) {
            DB::rollBack();
            return redirect()
                ->route('admin.pembayaran.index')
                ->with('error', 'Gagal menghapus Pembayaran: ' . $e->getMessage());
        }
    }
}
