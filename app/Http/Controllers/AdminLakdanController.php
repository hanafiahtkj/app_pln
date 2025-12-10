<?php

namespace App\Http\Controllers;

use App\Models\Rendan; // Tetap digunakan untuk relasi
use App\Models\Lakdan; // Model baru untuk Lakdan (Pelaksanaan Pengadaan)
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Exception;

class AdminLakdanController extends Controller
{
    /**
     * Tampilkan daftar data Lakdan.
     */
    public function index(Request $request)
    {
        // Eager load relasi rendan
        $data = Lakdan::latest()
            ->with('rendan')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Lakdan/IndexPage', [
            'data' => $data,
        ]);
    }

    /**
     * Tampilkan form untuk membuat Lakdan baru.
     */
    public function create()
    {
        // Menyediakan daftar Rendan untuk dipilih sebagai foreign key
        $rendans = Rendan::select('id', 'nomor_nd_user')->get();

        return Inertia::render('Admin/Lakdan/CreatePage', [
            'rendans' => $rendans,
        ]);
    }

    /**
     * Tampilkan form untuk mengedit Lakdan.
     */
    public function edit($id)
    {
        $lakdan = Lakdan::findOrFail($id);
        $rendans = Rendan::select('id', 'nomor_nd_user')->get();

        return Inertia::render('Admin/Lakdan/EditPage', [
            'data' => $lakdan,
            'rendans' => $rendans,
        ]);
    }

    // --- STORE METHOD (Tambah Data) ---
    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'rendan_id' => ['required', 'exists:rendans,id'], // Foreign key ke Rendan

            // Core Lakdan Fields
            'proses_pengadaan' => ['nullable', 'string'],
            'metode_pengadaan' => ['nullable', 'string'],

            // HPS Fields
            'rencana_tanggal_hps' => ['nullable', 'date'],
            'realisasi_tanggal_hps' => ['nullable', 'date'],
            'nomor_hps' => ['nullable', 'string'],
            'nilai_hps' => ['nullable', 'numeric'],
            'dokumen_hps_path' => ['nullable', 'string'], // Path sementara
            'dokumen_hps_name' => ['nullable', 'string'], // Nama file

            // Pengumuman Lelang Fields
            'rencana_pengumuman_lelang' => ['nullable', 'date'],
            'realisasi_pengumuman_lelang' => ['nullable', 'date'],
            'nomor_pengumuman_lelang' => ['nullable', 'string'],

            // Penunjukan Pemenang Fields
            'rencana_penunjukan_pemenang' => ['nullable', 'date'],
            'realisasi_penunjukan_pemenang' => ['nullable', 'date'],
            'nomor_penunjukan_pemenang' => ['nullable', 'string'],
            'dokumen_penunjukan_pemenang_path' => ['nullable', 'string'], // Path sementara
            'dokumen_penunjukan_pemenang_name' => ['nullable', 'string'], // Nama file
        ]);

        $finalPaths = [];
        $tempPaths = [
            'hps' => $validated['dokumen_hps_path'] ?? null,
            'penunjukan_pemenang' => $validated['dokumen_penunjukan_pemenang_path'] ?? null,
        ];

        $finalDirectories = [
            'hps' => 'lakdan_dokumen/hps',
            'penunjukan_pemenang' => 'lakdan_dokumen/pemenang',
        ];

        try {
            DB::beginTransaction();

            $lakdanData = $validated;

            // 2. LOGIKA PENANGANAN FILE
            foreach ($tempPaths as $key => $tempPath) {
                $dbField = "dokumen_{$key}"; // e.g., dokumen_hps

                if ($tempPath) {
                    if (!Storage::disk('public')->exists($tempPath)) {
                        throw new Exception("File dokumen {$key} tidak ditemukan di lokasi sementara. Harap unggah ulang.");
                    }

                    $fileName = $validated["dokumen_{$key}_name"] ?? basename($tempPath);
                    $finalPath = $finalDirectories[$key] . '/' . $fileName;

                    // Pindahkan file dan simpan path final
                    Storage::disk('public')->move($tempPath, $finalPath);
                    $finalPaths[$key] = $finalPath; // Simpan untuk rollback jika gagal
                    $lakdanData[$dbField] = $finalPath; // Field DB

                } else {
                    $lakdanData[$dbField] = null;
                }

                // Hapus field path dan name dari data yang akan disimpan
                unset($lakdanData["dokumen_{$key}_path"]);
                unset($lakdanData["dokumen_{$key}_name"]);
            }

            // 3. Simpan data Lakdan ke database
            Lakdan::create($lakdanData);

            DB::commit();

            return redirect()
                ->route('admin.lakdan.index')
                ->with('success', 'Data Pelaksanaan Pengadaan berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file yang sudah terlanjur dipindahkan
            foreach ($finalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Pelaksanaan Pengadaan: ' . $e->getMessage());
        }
    }

    // --- UPDATE METHOD (Edit Data) ---
    public function update(Request $request, $id)
    {
        $lakdan = Lakdan::findOrFail($id);

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'rendan_id' => ['required', 'exists:rendans,id'],

            // Core Lakdan Fields
            'proses_pengadaan' => ['nullable', 'string'],
            'metode_pengadaan' => ['nullable', 'string'],

            // HPS Fields
            'rencana_tanggal_hps' => ['nullable', 'date'],
            'realisasi_tanggal_hps' => ['nullable', 'date'],
            'nomor_hps' => ['nullable', 'string'],
            'nilai_hps' => ['nullable', 'numeric'],
            'dokumen_hps_path' => ['nullable', 'string'],
            'dokumen_hps_name' => ['nullable', 'string'],

            // Pengumuman Lelang Fields
            'rencana_pengumuman_lelang' => ['nullable', 'date'],
            'realisasi_pengumuman_lelang' => ['nullable', 'date'],
            'nomor_pengumuman_lelang' => ['nullable', 'string'],

            // Penunjukan Pemenang Fields
            'rencana_penunjukan_pemenang' => ['nullable', 'date'],
            'realisasi_penunjukan_pemenang' => ['nullable', 'date'],
            'nomor_penunjukan_pemenang' => ['nullable', 'string'],
            'dokumen_penunjukan_pemenang_path' => ['nullable', 'string'],
            'dokumen_penunjukan_pemenang_name' => ['nullable', 'string'],
        ]);

        $newFinalPaths = [];
        $oldFilePaths = [
            'hps' => $lakdan->dokumen_hps,
            'penunjukan_pemenang' => $lakdan->dokumen_penunjukan_pemenang,
        ];
        $tempPaths = [
            'hps' => $validated['dokumen_hps_path'] ?? null,
            'penunjukan_pemenang' => $validated['dokumen_penunjukan_pemenang_path'] ?? null,
        ];
        $finalDirectories = [
            'hps' => 'lakdan_dokumen/hps',
            'penunjukan_pemenang' => 'lakdan_dokumen/pemenang',
        ];

        try {
            DB::beginTransaction();

            $lakdanData = $validated;

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
                    $lakdanData[$dbField] = $newFinalPath; // Simpan path baru ke DB

                } else {
                    // Jika tidak ada upload baru, pertahankan nilai path dokumen yang lama dari model
                    $lakdanData[$dbField] = $lakdan->{$dbField};
                }

                // Hapus field path dan name sementara
                unset($lakdanData["dokumen_{$key}_path"]);
                unset($lakdanData["dokumen_{$key}_name"]);
            }

            // 3. Update data Lakdan
            $lakdan->update($lakdanData);

            DB::commit();

            return redirect()
                ->route('admin.lakdan.index')
                ->with('success', 'Data Pelaksanaan Pengadaan berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file baru yang sudah terlanjur dipindahkan
            foreach ($newFinalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Pelaksanaan Pengadaan: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Lakdan::findOrFail($id);

            // Hapus file dokumen terkait sebelum menghapus record
            if ($data->dokumen_hps && Storage::disk('public')->exists($data->dokumen_hps)) {
                Storage::disk('public')->delete($data->dokumen_hps);
            }
            if ($data->dokumen_penunjukan_pemenang && Storage::disk('public')->exists($data->dokumen_penunjukan_pemenang)) {
                Storage::disk('public')->delete($data->dokumen_penunjukan_pemenang);
            }

            $data->delete();
            DB::commit();

            return redirect()
                ->route('admin.lakdan.index')
                ->with('success', 'Data Pelaksanaan Pengadaan dan file terkait berhasil dihapus.');
        } catch (Exception $e) {
            DB::rollBack();
            return redirect()
                ->route('admin.lakdan.index')
                ->with('error', 'Gagal menghapus Pelaksanaan Pengadaan: ' . $e->getMessage());
        }
    }
}
