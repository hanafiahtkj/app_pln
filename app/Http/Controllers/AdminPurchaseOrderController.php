<?php

namespace App\Http\Controllers;

use App\Models\Kontrak; // Model untuk relasi (Foreign Key)
use App\Models\PurchaseOrder; // Model utama (PurchaseOrder)
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Exception;

class AdminPurchaseOrderController extends Controller
{
    /**
     * Daftar kolom dokumen yang perlu ditangani.
     */
    private array $documentFields = [
        'dokumen_po',
        'dokumen_pemeriksaan_mos',
        'ba_pemeriksaan_25',
        'ba_pemeriksaan_50',
        'ba_pemeriksaan_75',
        'ba_stp',
        'ba_stap',
    ];

    /**
     * Menghasilkan aturan validasi yang dapat digunakan kembali.
     */
    private function getValidationRules($id = null): array
    {
        $rules = [
            'kontrak_id' => ['required', 'exists:kontraks,id'],

            // --- Date Fields ---
            'rencana_po' => ['nullable', 'date'],
            'realisasi_po' => ['nullable', 'date'],
            'rencana_mos' => ['nullable', 'date'],
            'realisasi_mos' => ['nullable', 'date'],
            'rencana_progress_25' => ['nullable', 'date'],
            'realisasi_progress_25' => ['nullable', 'date'],
            'rencana_progress_50' => ['nullable', 'date'],
            'realisasi_progress_50' => ['nullable', 'date'],
            'rencana_progress_75' => ['nullable', 'date'],
            'realisasi_progress_75' => ['nullable', 'date'],
            'rencana_cod' => ['nullable', 'date'],
            'realisasi_cod' => ['nullable', 'date'],

            // --- Keterangan ---
            'keterangan' => ['nullable', 'string'],
        ];

        // Tambahkan aturan untuk path dokumen (yang disimpan ke DB) dan path/name sementara (dari form)
        foreach ($this->documentFields as $field) {
            $rules[$field] = ['nullable', 'string']; // Path di DB
            $rules["{$field}_path"] = ['nullable', 'string']; // Path sementara dari upload
            $rules["{$field}_name"] = ['nullable', 'string']; // Nama file asli
        }

        return $rules;
    }

    /**
     * Handle pemindahan file dari lokasi sementara ke lokasi permanen.
     * Dapat digunakan untuk store() dan update().
     */
    private function handleDocumentUploads(Request $request, array &$poData, PurchaseOrder $existingPo = null): array
    {
        $newFinalPaths = [];
        $finalDirectory = 'po_dokumen';

        foreach ($this->documentFields as $dbField) {
            $tempPathKey = "{$dbField}_path";
            $fileNameKey = "{$dbField}_name";

            $tempPath = $request->input($tempPathKey);
            $oldPath = $existingPo?->{$dbField};

            if ($tempPath) {
                // Ada upload baru
                if (!Storage::disk('public')->exists($tempPath)) {
                    throw new Exception("File dokumen ({$dbField}) tidak ditemukan di lokasi sementara. Harap unggah ulang.");
                }

                $fileName = $request->input($fileNameKey) ?? basename($tempPath);
                $newFinalPath = $finalDirectory . '/' . $fileName;

                // Hapus file lama (hanya saat update)
                if ($existingPo && $oldPath && Storage::disk('public')->exists($oldPath)) {
                    Storage::disk('public')->delete($oldPath);
                }

                // Pindahkan file baru
                Storage::disk('public')->move($tempPath, $newFinalPath);

                $newFinalPaths[$dbField] = $newFinalPath; // Simpan untuk rollback
                $poData[$dbField] = $newFinalPath; // Update data untuk disimpan ke DB

            } elseif ($existingPo) {
                // Pertahankan path file lama
                $poData[$dbField] = $oldPath;
            } else {
                // Pastikan null jika tidak ada file (untuk store)
                $poData[$dbField] = null;
            }

            // Hapus field path dan name sementara dari data
            unset($poData[$tempPathKey]);
            unset($poData[$fileNameKey]);
        }

        return $newFinalPaths;
    }

    /**
     * Tampilkan daftar data Purchase Order.
     */
    public function index(Request $request)
    {
        // Eager load relasi kontrak
        $data = PurchaseOrder::latest()
            ->with('kontrak')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/PurchaseOrder/IndexPage', [
            'data' => $data,
        ]);
    }

    /**
     * Tampilkan form untuk membuat Purchase Order baru.
     */
    public function create()
    {
        // Menyediakan daftar Kontrak untuk dipilih sebagai foreign key
        // Menggunakan nomor perjanjian Kontrak sebagai label
        $kontraks = Kontrak::select('id', 'nomor_perjanjian')->get();

        return Inertia::render('Admin/PurchaseOrder/CreatePage', [
            'kontraks' => $kontraks,
        ]);
    }

    /**
     * Tampilkan form untuk mengedit Purchase Order.
     */
    public function edit($id)
    {
        $po = PurchaseOrder::findOrFail($id);
        $kontraks = Kontrak::select('id', 'nomor_perjanjian')->get();

        return Inertia::render('Admin/PurchaseOrder/EditPage', [
            'data' => $po,
            'kontraks' => $kontraks,
        ]);
    }

    // --- STORE METHOD (Tambah Data) ---
    public function store(Request $request)
    {
        $validated = $request->validate($this->getValidationRules());

        $poData = $validated;
        $newFinalPaths = [];

        try {
            DB::beginTransaction();

            // 1. LOGIKA PENANGANAN FILE
            $newFinalPaths = $this->handleDocumentUploads($request, $poData);

            // 2. Simpan data Purchase Order ke database
            PurchaseOrder::create($poData);

            DB::commit();

            return redirect()
                ->route('admin.po.index')
                ->with('success', 'Data Purchase Order dan Progres berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file yang sudah terlanjur dipindahkan
            foreach ($newFinalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Purchase Order: ' . $e->getMessage());
        }
    }

    // --- UPDATE METHOD (Edit Data) ---
    public function update(Request $request, $id)
    {
        $po = PurchaseOrder::findOrFail($id);

        $validated = $request->validate($this->getValidationRules($id));

        $poData = $validated;
        $newFinalPaths = [];

        try {
            DB::beginTransaction();

            // 1. LOGIKA PEMINDAHAN FILE
            // File handling akan menangani penghapusan file lama jika ada file baru diupload
            $newFinalPaths = $this->handleDocumentUploads($request, $poData, $po);

            // 2. Update data Purchase Order
            $po->update($poData);

            DB::commit();

            return redirect()
                ->route('admin.po.index')
                ->with('success', 'Data Purchase Order dan Progres berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file baru yang sudah terlanjur dipindahkan
            foreach ($newFinalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Purchase Order: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = PurchaseOrder::findOrFail($id);

            // Hapus semua file dokumen terkait sebelum menghapus record
            foreach ($this->documentFields as $dbField) {
                $path = $data->{$dbField};
                if ($path && Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }

            $data->delete();
            DB::commit();

            return redirect()
                ->route('admin.po.index')
                ->with('success', 'Data Purchase Order dan file terkait berhasil dihapus.');
        } catch (Exception $e) {
            DB::rollBack();
            return redirect()
                ->route('admin.po.index')
                ->with('error', 'Gagal menghapus Purchase Order: ' . $e->getMessage());
        }
    }
}
