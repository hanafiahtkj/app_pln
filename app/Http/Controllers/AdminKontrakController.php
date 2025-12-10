<?php

namespace App\Http\Controllers;

use App\Models\Lakdan; // Model untuk relasi (Foreign Key)
use App\Models\Kontrak; // Model utama (Kontrak)
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Exception;

class AdminKontrakController extends Controller
{
    /**
     * Tampilkan daftar data Kontrak.
     */
    public function index(Request $request)
    {
        // Eager load relasi lakdan
        $data = Kontrak::latest()
            ->with('lakdan')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Kontrak/IndexPage', [
            'data' => $data,
        ]);
    }

    /**
     * Tampilkan form untuk membuat Kontrak baru.
     */
    public function create()
    {
        // Menyediakan daftar Lakdan untuk dipilih sebagai foreign key
        // Menggunakan nomor HPS Lakdan sebagai label
        $lakdans = Lakdan::select('id', 'nomor_hps')->get();

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
        $lakdans = Lakdan::select('id', 'nomor_hps')->get();

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
            'dokumen_perjanjian_path' => ['nullable', 'string'],
            'dokumen_perjanjian_name' => ['nullable', 'string'],
            'dokumen_jaminan_pelaksanaan_path' => ['nullable', 'string'],
            'dokumen_jaminan_pelaksanaan_name' => ['nullable', 'string'],
        ]);

        $finalPaths = [];
        $tempPaths = [
            'perjanjian' => $validated['dokumen_perjanjian_path'] ?? null,
            'jaminan_pelaksanaan' => $validated['dokumen_jaminan_pelaksanaan_path'] ?? null,
        ];

        $finalDirectories = [
            'perjanjian' => 'kontrak_dokumen/perjanjian',
            'jaminan_pelaksanaan' => 'kontrak_dokumen/jaminan_pelaksanaan',
        ];

        try {
            DB::beginTransaction();

            $kontrakData = $validated;

            // 2. LOGIKA PENANGANAN FILE
            foreach ($tempPaths as $key => $tempPath) {
                $dbField = "dokumen_{$key}"; // e.g., dokumen_perjanjian

                if ($tempPath) {
                    if (!Storage::disk('public')->exists($tempPath)) {
                        throw new Exception("File dokumen {$key} tidak ditemukan di lokasi sementara. Harap unggah ulang.");
                    }

                    $fileName = $validated["dokumen_{$key}_name"] ?? basename($tempPath);
                    $finalPath = $finalDirectories[$key] . '/' . $fileName;

                    // Pindahkan file dan simpan path final
                    Storage::disk('public')->move($tempPath, $finalPath);
                    $finalPaths[$key] = $finalPath; // Simpan untuk rollback jika gagal
                    $kontrakData[$dbField] = $finalPath; // Field DB

                } else {
                    // Pastikan field dokumen di DB bernilai null jika tidak ada path/name
                    $kontrakData[$dbField] = null;
                }

                // Hapus field path dan name dari data yang akan disimpan
                unset($kontrakData["dokumen_{$key}_path"]);
                unset($kontrakData["dokumen_{$key}_name"]);
            }

            // 3. Simpan data Kontrak ke database
            Kontrak::create($kontrakData);

            DB::commit();

            return redirect()
                ->route('admin.kontrak.index')
                ->with('success', 'Data Kontrak berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file yang sudah terlanjur dipindahkan
            foreach ($finalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
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
            'dokumen_perjanjian_path' => ['nullable', 'string'],
            'dokumen_perjanjian_name' => ['nullable', 'string'],
            'dokumen_jaminan_pelaksanaan_path' => ['nullable', 'string'],
            'dokumen_jaminan_pelaksanaan_name' => ['nullable', 'string'],
        ]);

        $newFinalPaths = [];
        $oldFilePaths = [
            'perjanjian' => $kontrak->dokumen_perjanjian,
            'jaminan_pelaksanaan' => $kontrak->dokumen_jaminan_pelaksanaan,
        ];
        $tempPaths = [
            'perjanjian' => $validated['dokumen_perjanjian_path'] ?? null,
            'jaminan_pelaksanaan' => $validated['dokumen_jaminan_pelaksanaan_path'] ?? null,
        ];
        $finalDirectories = [
            'perjanjian' => 'kontrak_dokumen/perjanjian',
            'jaminan_pelaksanaan' => 'kontrak_dokumen/jaminan_pelaksanaan',
        ];

        try {
            DB::beginTransaction();

            $kontrakData = $validated;

            // 2. LOGIKA PEMINDAHAN FILE
            foreach ($tempPaths as $key => $tempPath) {
                $dbField = "dokumen_{$key}";

                if ($tempPath) {
                    // Ada upload baru
                    if (!Storage::disk('public')->exists($tempPath)) {
                        throw new Exception("File dokumen {$key} yang baru tidak ditemukan di lokasi sementara. Harap unggah ulang.");
                    }

                    $fileName = $validated["dokumen_{$key}_name"] ?? basename($tempPath);
                    $newFinalPath = $finalDirectories[$key] . '/' . $fileName;

                    // Hapus file lama jika ada
                    if ($oldFilePaths[$key] && Storage::disk('public')->exists($oldFilePaths[$key])) {
                        Storage::disk('public')->delete($oldFilePaths[$key]);
                    }

                    // Pindahkan file baru
                    Storage::disk('public')->move($tempPath, $newFinalPath);

                    $newFinalPaths[$key] = $newFinalPath; // Simpan untuk rollback
                    $kontrakData[$dbField] = $newFinalPath; // Simpan path baru ke DB

                } else {
                    // Jika tidak ada upload baru, pertahankan nilai path dokumen yang lama dari model
                    $kontrakData[$dbField] = $kontrak->{$dbField};
                }

                // Hapus field path dan name sementara
                unset($kontrakData["dokumen_{$key}_path"]);
                unset($kontrakData["dokumen_{$key}_name"]);
            }

            // 3. Update data Kontrak
            $kontrak->update($kontrakData);

            DB::commit();

            return redirect()
                ->route('admin.kontrak.index')
                ->with('success', 'Data Kontrak berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file baru yang sudah terlanjur dipindahkan
            foreach ($newFinalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Kontrak: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Kontrak::findOrFail($id);

            // Hapus file dokumen terkait sebelum menghapus record
            if ($data->dokumen_perjanjian && Storage::disk('public')->exists($data->dokumen_perjanjian)) {
                Storage::disk('public')->delete($data->dokumen_perjanjian);
            }
            if ($data->dokumen_jaminan_pelaksanaan && Storage::disk('public')->exists($data->dokumen_jaminan_pelaksanaan)) {
                Storage::disk('public')->delete($data->dokumen_jaminan_pelaksanaan);
            }

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
}
