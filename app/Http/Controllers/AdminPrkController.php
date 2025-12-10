<?php

namespace App\Http\Controllers;

use App\Models\MasterKondisiFisik;
use App\Models\MasterMediaSimpan;
use App\Models\MasterTingkatPerkembangan;
use App\Models\Prk;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class AdminPrkController extends Controller
{
    public function __construct()
    {
        // $this->middleware('permission:manage-holidays');
    }

    public function index(Request $request)
    {
        $data = Prk::latest()
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Prk/IndexPage', [
            'data' => $data,
        ]);
    }

    public function create()
    {
        // $this->authorize('create-lapangan');

        return Inertia::render('Admin/Prk/CreatePage', [

        ]);
    }

    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi sesuai skema PRK
        $validated = $request->validate([
            'tahun' => ['required', 'integer', 'digits:4'],
            'prk' => ['required', 'string', Rule::unique('prks', 'prk')], // Pastikan PRK unik di tabel 'prks'
            'fungsi' => ['required', 'string'],
            'uraian' => ['required', 'string'],
            'status' => ['required', 'string'],
            'ai_rupiah' => ['required', 'numeric'],
            'user' => ['required', 'string'],

            // Dokumen Kaji Ulang
            'dokumen_kkp' => ['nullable', 'string'],
            'tanggal_kkp' => ['nullable', 'date'],
            'ulasan_kajian_risiko' => ['nullable', 'string'],
            'tanggal_ulasan_kajian_risiko' => ['nullable', 'date'],
            'dokumen_grc' => ['nullable', 'string'],
            'tanggal_dokumen_grc' => ['nullable', 'date'],

            // TVV
            'tanggal_tvv' => ['nullable', 'date'],
            'status_persetujuan_tvv' => ['nullable', 'string'],
            'dokumen_tvv' => ['nullable', 'string'],

            // SKAI & Paket
            'nomor_skai' => ['nullable', 'string'],
            'tanggal_skai' => ['nullable', 'date'],
            'nilai_skai' => ['nullable', 'numeric'],
            'jumlah_paket' => ['nullable', 'integer'],

            // Dokumen SKAI (File Upload)
            'dokumen_skai_path' => ['nullable', 'string'],
            'dokumen_skai_name' => ['nullable', 'string'],
        ]);

        $tempPath = $validated['dokumen_skai_path'] ?? null;
        $finalPath = null;
        $finalDirectory = 'prk_dokumen/skai';

        try {
            DB::beginTransaction();

            $prkData = $validated;

            // 2. LOGIKA PENANGANAN FILE DOKUMEN SKAI
            if ($tempPath) {
                // Pastikan file sementara ada sebelum diproses
                if (!Storage::disk('public')->exists($tempPath)) {
                    throw new \Exception('File dokumen SKAI tidak ditemukan di lokasi sementara. Harap unggah ulang.');
                }

                // Tentukan path permanen
                // Menggunakan nama file asli (dari dokumen_skai_name) jika ada, atau menggunakan nama basename tempPath
                $fileName = $validated['dokumen_skai_name'] ?? basename($tempPath);
                $finalPath = $finalDirectory . '/' . $fileName;

                // Pastikan nama file unik (opsional, tergantung kebutuhan Anda)
                // $finalPath = $finalDirectory . '/' . time() . '_' . $fileName;

                // Pindahkan file dari 'temp_uploads' ke 'prk_dokumen/skai'
                Storage::disk('public')->move($tempPath, $finalPath);

                // Update data yang akan disimpan dengan path permanen
                $prkData['dokumen_skai'] = $finalPath;
            } else {
                // Jika tidak ada file diunggah, pastikan field dokumen_skai null
                $prkData['dokumen_skai'] = null;
            }

            // Hapus field path dan name dari data yang akan di-create
            unset($prkData['dokumen_skai_path']);
            unset($prkData['dokumen_skai_name']);

            // 3. Simpan data PRK ke database
            Prk::create($prkData);

            DB::commit();

            return redirect()
                ->route('admin.prk.index') // Sesuaikan route redirection
                ->with('success', 'Data PRK dan dokumen SKAI berhasil ditambahkan.');

        } catch (\Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file yang sudah terlanjur dipindahkan
            if ($finalPath && Storage::disk('public')->exists($finalPath)) {
                Storage::disk('public')->delete($finalPath);
            }
            return redirect()->back()->with('error', 'Gagal menyimpan data PRK: ' . $e->getMessage());
        }
    }

    public function edit($id)
    {
        // $this->authorize('update-arsip');

        // 1. Ambil data Prk berdasarkan ID
        $prk = Prk::findOrFail($id);

        return Inertia::render('Admin/Prk/EditPage', [
            'data' => $prk, // <-- Kirim data arsip yang akan diedit
        ]);
    }

    /**
     * Memperbarui data PRK di database.
     */
    public function update(Request $request, $id)
    {
        // Cari data yang akan diupdate
        $prk = Prk::findOrFail($id);

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'tahun' => ['required', 'integer', 'digits:4'],
            // Gunakan Rule::unique().ignore($prk->id) agar nomor PRK saat ini bisa dipertahankan
            'prk' => ['required', 'string', Rule::unique('prks', 'prk')->ignore($prk->id)],
            'fungsi' => ['required', 'string'],
            'uraian' => ['required', 'string'],
            'status' => ['required', 'string'],
            'ai_rupiah' => ['required', 'numeric'],
            'user' => ['required', 'string'],

            // Dokumen Kaji Ulang
            'dokumen_kkp' => ['nullable', 'string'],
            'tanggal_kkp' => ['nullable', 'date'],
            'ulasan_kajian_risiko' => ['nullable', 'string'],
            'tanggal_ulasan_kajian_risiko' => ['nullable', 'date'],
            'dokumen_grc' => ['nullable', 'string'],
            'tanggal_dokumen_grc' => ['nullable', 'date'],

            // TVV
            'tanggal_tvv' => ['nullable', 'date'],
            'status_persetujuan_tvv' => ['nullable', 'string'],
            'dokumen_tvv' => ['nullable', 'string'],

            // SKAI & Paket
            'nomor_skai' => ['nullable', 'string'],
            'tanggal_skai' => ['nullable', 'date'],
            'nilai_skai' => ['nullable', 'numeric'],
            'jumlah_paket' => ['nullable', 'integer'],

            // Dokumen SKAI (Path & Name dari pre-upload asinkron)
            'dokumen_skai_path' => ['nullable', 'string'],
            'dokumen_skai_name' => ['nullable', 'string'],
        ]);

        $tempPath = $validated['dokumen_skai_path'] ?? null;
        $finalPath = $prk->dokumen_skai; // Path default adalah path yang sudah ada
        $oldFilePath = $prk->dokumen_skai;
        $finalDirectory = 'prk_dokumen/skai';

        try {
            DB::beginTransaction();

            $prkData = $validated;

            // 2. LOGIKA PEMINDAHAN FILE DOKUMEN SKAI (HANYA JIKA ADA UPLOAD BARU)
            if ($tempPath) {
                if (!Storage::disk('public')->exists($tempPath)) {
                    throw new \Exception('File dokumen SKAI yang baru tidak ditemukan di lokasi sementara. Harap unggah ulang.');
                }

                // Tentukan nama file permanen
                $fileName = $validated['dokumen_skai_name'] ?? basename($tempPath);
                $finalPath = $finalDirectory . '/' . $fileName;

                // Hapus file lama jika ada
                if ($oldFilePath && Storage::disk('public')->exists($oldFilePath)) {
                    Storage::disk('public')->delete($oldFilePath);
                }

                // Pindahkan file dari lokasi sementara ke lokasi permanen
                Storage::disk('public')->move($tempPath, $finalPath);

                // Simpan path permanen di field dokumen_skai
                $prkData['dokumen_skai'] = $finalPath;
            } else {
                // Jika tidak ada upload baru, pertahankan path lama.
                $prkData['dokumen_skai'] = $oldFilePath;
            }

            // Hapus field path dan name yang hanya digunakan untuk proses pemindahan
            unset($prkData['dokumen_skai_path']);
            unset($prkData['dokumen_skai_name']);

            // 3. Update data PRK
            $prk->update($prkData);

            DB::commit();

            return redirect()
                ->route('admin.prk.index')
                ->with('success', 'Data PRK dan dokumen SKAI berhasil diperbarui.');

        } catch (\Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file baru yang sudah terlanjur dipindahkan
            if ($tempPath && $finalPath && Storage::disk('public')->exists($finalPath)) {
                Storage::disk('public')->delete($finalPath);
            }
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data PRK: ' . $e->getMessage());
        }
    }

    public function destroy($id)
    {
        // $this->authorize('delete-holidays');

        try {
            $data = Prk::findOrFail($id);
            $data->delete();

            return redirect()
                ->route('admin.prk.index')
                ->with('success', 'Data berhasil dihapus.');
        } catch (\Exception $e) {
            return redirect()
                ->route('admin.prk.index')
                ->with('error', 'Gagal menghapus: ' . $e->getMessage());
        }
    }
}
