<?php

namespace App\Http\Controllers;

use App\Models\Prk;
use App\Models\Bidang;
use App\Models\Unit;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Auth;
use App\Services\DataTablePaginationService;

class AdminPrkController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-prk');
    }

    public function index(Request $request)
    {
        $perPage = $this->pagination->resolvePerPageWithDefaults($request);

        // 1. Mulai query dasar
        $query = Prk::with([
            'bidang',
            'unit',
        ])->latest();

        // 2. Ambil user yang sedang login
        $user = auth()->user();

        // 3. Cek apakah user memiliki role 'user' (menggunakan spatie)
        // Asumsi: kolom di tabel prks adalah 'unit_id' dan di tabel users adalah 'unit_id'
        if ($user->hasRole('user')) {
            $query->where('unit_id', $user->unit_id);
        }

        if ($request->filled('tahun')) {
            $query->where('tahun', $request->tahun);
        }

        // 4. Eksekusi pagination
        $data = $query->paginate($perPage);

        return Inertia::render('Admin/Prk/IndexPage', [
            'data' => $data,
        ]);
    }

    public function create()
    {
        // $this->authorize('create-lapangan');

        return Inertia::render('Admin/Prk/CreatePage', [
            'bidangs' => [
                'data' => Bidang::select(['id', 'name'])->get(),
            ],
            'units' => [
                'data' => Unit::select(['id', 'kode', 'name'])->get(),
            ],
        ]);
    }

    public function store(Request $request)
    {
        $user = Auth::user();

        // 1. Tentukan aturan validasi sesuai skema PRK
        $validated = $request->validate([
            'tahun' => ['required', 'integer', 'digits:4'],
            'prk' => ['required', 'string', Rule::unique('prks', 'prk')], // Pastikan PRK unik di tabel 'prks'
            'fungsi' => ['required', 'string'],
            'uraian' => ['required', 'string'],
            'status' => ['required', 'string'],
            'ai_rupiah' => ['required', 'numeric'],
            'bidang_id' => ['required', 'exists:bidangs,id'],
            'unit_id' => ['required', 'exists:units,id'],

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
            'dokumen_skai' => ['nullable', 'string'],

            'file_kkp' => ['nullable', 'string'],
            'file_kajian_risiko' => ['nullable', 'string'],
            'file_grc' => ['nullable', 'string'],
            'file_tvv' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $prkData = $validated;

            $prkData['user_id'] = $user->id;
            // $prkData['unit_id'] = $user->unit_id;

            Prk::create($prkData);

            DB::commit();

            return redirect()
                ->route('admin.prk.index') // Sesuaikan route redirection
                ->with('success', 'Data PRK dan dokumen SKAI berhasil ditambahkan.');

        } catch (\Exception $e) {
            DB::rollBack();

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
            'bidangs' => [
                'data' => Bidang::select(['id', 'name'])->get(),
            ],
            'units' => [
                'data' => Unit::select(['id', 'kode', 'name'])->get(),
            ],
        ]);
    }

    /**
     * Memperbarui data PRK di database.
     */
    public function update(Request $request, $id)
    {
        // Cari data yang akan diupdate
        $prk = Prk::findOrFail($id);
        $user = Auth::user();

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'tahun' => ['required', 'integer', 'digits:4'],
            // Gunakan Rule::unique().ignore($prk->id) agar nomor PRK saat ini bisa dipertahankan
            'prk' => ['required', 'string', Rule::unique('prks', 'prk')->ignore($prk->id)],
            'fungsi' => ['required', 'string'],
            'uraian' => ['required', 'string'],
            'status' => ['required', 'string'],
            'ai_rupiah' => ['nullable', 'numeric'],
            'bidang_id' => ['required', 'exists:bidangs,id'],
            'unit_id' => ['required', 'exists:units,id'],

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
            'dokumen_skai' => ['nullable', 'string'],

            'file_kkp' => ['nullable', 'string'],
            'file_kajian_risiko' => ['nullable', 'string'],
            'file_grc' => ['nullable', 'string'],
            'file_tvv' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $prkData = $validated;

            // $prkData['user_id'] = $user->id;
            // $prkData['unit_id'] = $user->unit_id;

            $prk->update($prkData);

            DB::commit();

            return redirect()
                ->route('admin.prk.index')
                ->with('success', 'Data PRK dan dokumen SKAI berhasil diperbarui.');

        } catch (\Exception $e) {
            DB::rollBack();

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

    public function show($id)
    {
        $paket = Prk::with([
            'bidang',
            'unit',
        ])->findOrFail($id);

        return Inertia::render('Admin/Prk/ShowPage', [
            'data' => $paket,
        ]);
    }
}
