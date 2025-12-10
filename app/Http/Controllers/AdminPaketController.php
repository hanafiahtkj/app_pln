<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use App\Models\Prk;

class AdminPaketController extends Controller
{
    public function __construct()
    {
        // $this->middleware('permission:manage-holidays');
    }

    public function index(Request $request)
    {
        // Inisialisasi query data Paket
        $data = Paket::latest()
            ->with('prk')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Paket/IndexPage', [
            'data' => $data,
        ]);
    }

    public function create()
    {
        // $this->authorize('create-lapangan');

        return Inertia::render('Admin/Paket/CreatePage', [
            'prks' => Prk::select('id', 'prk')->get(),
        ]);
    }

    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi sesuai skema tabel `pakets`
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'], // Foreign Key ke tabel prks
            'tahun' => ['required', 'integer', 'digits:4'],

            // SKK Fields
            'nomor_skk' => ['required', 'string', Rule::unique('pakets', 'nomor_skk')], // Nomor SKK harus unik
            'tanggal_skk' => ['nullable', 'date'],
            'nilai_skk' => ['nullable', 'numeric'],
            'status_paket' => ['nullable', 'string'],

            // Dokumen SKK (File Upload dari pre-upload asinkron)
            'dokumen_skk_path' => ['nullable', 'string'],
            'dokumen_skk_name' => ['nullable', 'string'],
        ]);

        $tempPath = $validated['dokumen_skk_path'] ?? null;
        $finalPath = null;
        $finalDirectory = 'paket_dokumen/skk'; // Direktori penyimpanan file SKK

        try {
            DB::beginTransaction();

            $paketData = $validated;

            // 2. LOGIKA PENANGANAN FILE DOKUMEN SKK
            if ($tempPath) {
                if (!Storage::disk('public')->exists($tempPath)) {
                    throw new \Exception('File dokumen SKK tidak ditemukan di lokasi sementara. Harap unggah ulang.');
                }

                // Tentukan path permanen
                $fileName = $validated['dokumen_skk_name'] ?? basename($tempPath);
                $finalPath = $finalDirectory . '/' . $fileName;

                // Pindahkan file dari 'temp_uploads' ke lokasi permanen
                Storage::disk('public')->move($tempPath, $finalPath);

                // Update data yang akan disimpan dengan path permanen
                $paketData['dokumen_skk'] = $finalPath;
            } else {
                // Jika tidak ada file diunggah
                $paketData['dokumen_skk'] = null;
            }

            // Hapus field path dan name yang hanya digunakan untuk proses pemindahan
            unset($paketData['dokumen_skk_path']);
            unset($paketData['dokumen_skk_name']);

            // 3. Simpan data Paket ke database
            Paket::create($paketData);

            DB::commit();

            return redirect()
                ->route('admin.paket.index')
                ->with('success', 'Data Paket dan dokumen SKK berhasil ditambahkan.');

        } catch (\Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file yang sudah terlanjur dipindahkan
            if ($finalPath && Storage::disk('public')->exists($finalPath)) {
                Storage::disk('public')->delete($finalPath);
            }
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Paket: ' . $e->getMessage());
        }
    }

    public function edit($id)
    {
        // $this->authorize('update-arsip');

        // 1. Ambil data Paket berdasarkan ID
        $paket = Paket::findOrFail($id);

        return Inertia::render('Admin/Paket/EditPage', [
            'data' => $paket, // <-- Kirim data paket yang akan diedit
            'prks' => Prk::select('id', 'prk')->get(),
        ]);
    }

    /**
     * Memperbarui data Paket di database.
     */
    public function update(Request $request, $id)
    {
        // Cari data yang akan diupdate
        $paket = Paket::findOrFail($id);

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'],
            'tahun' => ['required', 'integer', 'digits:4'],

            // SKK Fields
            // Abaikan Nomor SKK saat ini untuk validasi unique
            'nomor_skk' => ['required', 'string', Rule::unique('pakets', 'nomor_skk')->ignore($paket->id)],
            'tanggal_skk' => ['nullable', 'date'],
            'nilai_skk' => ['nullable', 'numeric'],
            'status_paket' => ['nullable', 'string'],

            // Dokumen SKK (Path & Name dari pre-upload asinkron)
            'dokumen_skk_path' => ['nullable', 'string'],
            'dokumen_skk_name' => ['nullable', 'string'],
        ]);

        $tempPath = $validated['dokumen_skk_path'] ?? null;
        $oldFilePath = $paket->dokumen_skk;
        $finalDirectory = 'paket_dokumen/skk';
        $newFinalPath = null;

        try {
            DB::beginTransaction();

            $paketData = $validated;

            // 2. LOGIKA PEMINDAHAN FILE DOKUMEN SKK (HANYA JIKA ADA UPLOAD BARU)
            if ($tempPath) {
                if (!Storage::disk('public')->exists($tempPath)) {
                    throw new \Exception('File dokumen SKK yang baru tidak ditemukan di lokasi sementara. Harap unggah ulang.');
                }

                // Tentukan nama file permanen
                $fileName = $validated['dokumen_skk_name'] ?? basename($tempPath);
                $newFinalPath = $finalDirectory . '/' . $fileName;

                // Hapus file lama jika ada
                if ($oldFilePath && Storage::disk('public')->exists($oldFilePath)) {
                    Storage::disk('public')->delete($oldFilePath);
                }

                // Pindahkan file dari lokasi sementara ke lokasi permanen
                Storage::disk('public')->move($tempPath, $newFinalPath);

                // Simpan path permanen di field dokumen_skk
                $paketData['dokumen_skk'] = $newFinalPath;
            }
            // Jika tidak ada upload baru, field 'dokumen_skk' akan tetap menggunakan nilai dari payload Inertia (path lama)
            // Kecuali jika user menghapus file dari form, yang akan mengirimkan null di dokumen_skk

            // Hapus field path dan name yang hanya digunakan untuk proses pemindahan
            unset($paketData['dokumen_skk_path']);
            unset($paketData['dokumen_skk_name']);

            // 3. Update data Paket
            $paket->update($paketData);

            DB::commit();

            return redirect()
                ->route('admin.paket.index')
                ->with('success', 'Data Paket dan dokumen SKK berhasil diperbarui.');

        } catch (\Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file baru yang sudah terlanjur dipindahkan
            if ($newFinalPath && Storage::disk('public')->exists($newFinalPath)) {
                Storage::disk('public')->delete($newFinalPath);
            }
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Paket: ' . $e->getMessage());
        }
    }

    public function destroy($id)
    {
        // $this->authorize('delete-holidays');

        try {
            $data = Paket::findOrFail($id);
            $data->delete();

            return redirect()
                ->route('admin.paket.index')
                ->with('success', 'Data Paket berhasil dihapus.');
        } catch (\Exception $e) {
            return redirect()
                ->route('admin.paket.index')
                ->with('error', 'Gagal menghapus Paket: ' . $e->getMessage());
        }
    }
}
