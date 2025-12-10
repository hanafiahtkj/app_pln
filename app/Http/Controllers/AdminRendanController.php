<?php

namespace App\Http\Controllers;

use App\Models\Rendan;
use App\Models\Prk;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage; // Wajib diaktifkan kembali
use Exception;

class AdminRendanController extends Controller
{
    // ... (Metode __construct, index, create, dan edit tetap sama) ...

    public function index(Request $request)
    {
        $data = Rendan::latest()
            ->with('prk')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Rendan/IndexPage', [
            'data' => $data,
        ]);
    }

    public function create()
    {
        return Inertia::render('Admin/Rendan/CreatePage', [
            'prks' => Prk::select('id', 'prk')->get(),
        ]);
    }

    public function edit($id)
    {
        $rendan = Rendan::findOrFail($id);

        return Inertia::render('Admin/Rendan/EditPage', [
            'data' => $rendan,
            'prks' => Prk::select('id', 'prk')->get(),
        ]);
    }

    // --- STORE METHOD (Tambah Data) ---
    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'],

            // ND User Fields
            'nomor_nd_user' => ['nullable', 'string', Rule::unique('rendans', 'nomor_nd_user')],
            'tanggal_nd_user' => ['nullable', 'date'],
            'dokumen_nd_user_path' => ['nullable', 'string'], // Path sementara
            'dokumen_nd_user_name' => ['nullable', 'string'], // Nama file

            // RAB Field
            'rab' => ['nullable', 'string'],

            // RKS Fields
            'nomor_rks' => ['nullable', 'string'],
            'tanggal_rks' => ['nullable', 'date'],
            'dokumen_rks_path' => ['nullable', 'string'], // Path sementara
            'dokumen_rks_name' => ['nullable', 'string'], // Nama file
        ]);

        $finalPaths = [];
        $tempPaths = [
            'nd_user' => $validated['dokumen_nd_user_path'] ?? null,
            'rks' => $validated['dokumen_rks_path'] ?? null,
        ];

        $finalDirectories = [
            'nd_user' => 'rendan_dokumen/nd_user',
            'rks' => 'rendan_dokumen/rks',
        ];

        try {
            DB::beginTransaction();

            $rendanData = $validated;

            // 2. LOGIKA PENANGANAN FILE
            foreach ($tempPaths as $key => $tempPath) {
                if ($tempPath) {
                    if (!Storage::disk('public')->exists($tempPath)) {
                        throw new Exception("File dokumen {$key} tidak ditemukan di lokasi sementara. Harap unggah ulang.");
                    }

                    $fileName = $validated["dokumen_{$key}_name"] ?? basename($tempPath);
                    $finalPath = $finalDirectories[$key] . '/' . $fileName;

                    // Pindahkan file dan simpan path final
                    Storage::disk('public')->move($tempPath, $finalPath);
                    $finalPaths[$key] = $finalPath; // Simpan untuk rollback jika gagal
                    $rendanData["dokumen_{$key}"] = $finalPath; // Field DB

                } else {
                    $rendanData["dokumen_{$key}"] = null;
                }

                // Hapus field path dan name dari data yang akan disimpan
                unset($rendanData["dokumen_{$key}_path"]);
                unset($rendanData["dokumen_{$key}_name"]);
            }

            // 3. Simpan data Rendan ke database
            Rendan::create($rendanData);

            DB::commit();

            return redirect()
                ->route('admin.rendan.index')
                ->with('success', 'Data Rendan berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file yang sudah terlanjur dipindahkan
            foreach ($finalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Rendan: ' . $e->getMessage());
        }
    }

    // --- UPDATE METHOD (Edit Data) ---
    public function update(Request $request, $id)
    {
        $rendan = Rendan::findOrFail($id);

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'],

            // ND User Fields
            'nomor_nd_user' => [
                'nullable',
                'string',
                Rule::unique('rendans', 'nomor_nd_user')->ignore($rendan->id)
            ],
            'tanggal_nd_user' => ['nullable', 'date'],
            'dokumen_nd_user_path' => ['nullable', 'string'],
            'dokumen_nd_user_name' => ['nullable', 'string'],

            // RAB Field
            'rab' => ['nullable', 'string'],

            // RKS Fields
            'nomor_rks' => ['nullable', 'string'],
            'tanggal_rks' => ['nullable', 'date'],
            'dokumen_rks_path' => ['nullable', 'string'],
            'dokumen_rks_name' => ['nullable', 'string'],
        ]);

        $newFinalPaths = [];
        $oldFilePaths = [
            'nd_user' => $rendan->dokumen_nd_user,
            'rks' => $rendan->dokumen_rks,
        ];
        $tempPaths = [
            'nd_user' => $validated['dokumen_nd_user_path'] ?? null,
            'rks' => $validated['dokumen_rks_path'] ?? null,
        ];
        $finalDirectories = [
            'nd_user' => 'rendan_dokumen/nd_user',
            'rks' => 'rendan_dokumen/rks',
        ];

        try {
            DB::beginTransaction();

            $rendanData = $validated;

            // 2. LOGIKA PEMINDAHAN FILE
            foreach ($tempPaths as $key => $tempPath) {
                $dbField = "dokumen_{$key}"; // e.g., dokumen_nd_user

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
                    $rendanData[$dbField] = $newFinalPath; // Simpan path baru ke DB

                } else {
                    // Jika tidak ada upload baru, gunakan nilai path dokumen yang lama
                    $rendanData[$dbField] = $oldFilePaths[$key];
                }

                // Hapus field path dan name sementara
                unset($rendanData["dokumen_{$key}_path"]);
                unset($rendanData["dokumen_{$key}_name"]);
            }

            // 3. Update data Rendan
            $rendan->update($rendanData);

            DB::commit();

            return redirect()
                ->route('admin.rendan.index')
                ->with('success', 'Data Rendan berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();
            // Jika terjadi kegagalan, hapus file baru yang sudah terlanjur dipindahkan
            foreach ($newFinalPaths as $path) {
                if (Storage::disk('public')->exists($path)) {
                    Storage::disk('public')->delete($path);
                }
            }
            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Rendan: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Rendan::findOrFail($id);

            // Hapus file dokumen terkait sebelum menghapus record
            if ($data->dokumen_nd_user && Storage::disk('public')->exists($data->dokumen_nd_user)) {
                Storage::disk('public')->delete($data->dokumen_nd_user);
            }
            if ($data->dokumen_rks && Storage::disk('public')->exists($data->dokumen_rks)) {
                Storage::disk('public')->delete($data->dokumen_rks);
            }

            $data->delete();
            DB::commit();

            return redirect()
                ->route('admin.rendan.index')
                ->with('success', 'Data Rendans dan file terkait berhasil dihapus.');
        } catch (Exception $e) {
            DB::rollBack();
            return redirect()
                ->route('admin.rendan.index')
                ->with('error', 'Gagal menghapus Rendan: ' . $e->getMessage());
        }
    }
}
