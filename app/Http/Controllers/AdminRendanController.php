<?php

namespace App\Http\Controllers;

use App\Models\Rendan;
use App\Models\Enjiniring;
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
            ->with('enjiniring.paket.prk')
            ->paginate($request->input('per_page', 10));

        return Inertia::render('Admin/Rendan/IndexPage', [
            'data' => $data,
        ]);
    }

    public function create()
    {
        $enjinirings = Enjiniring::with('paket.prk')
            ->doesntHave('rendan')
            ->get();

        return Inertia::render('Admin/Rendan/CreatePage', [
            'enjinirings' => $enjinirings,
        ]);
    }

    public function edit($id)
    {
        $rendan = Rendan::findOrFail($id);

        $currentEnjiniringId = $rendan->enjiniring_id;

        $enjinirings = Enjiniring::with('paket.prk')
            ->where(function ($query) use ($currentEnjiniringId) {
                $query->doesntHave('rendan');
                $query->orWhere('id', $currentEnjiniringId);
            })
            ->get();

        return Inertia::render('Admin/Rendan/EditPage', [
            'data' => $rendan,
            'enjinirings' => $enjinirings,
        ]);
    }

    // --- STORE METHOD (Tambah Data) ---
    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'enjiniring_id' => ['required', 'exists:enjinirings,id'],

            // ND User Fields
            'nomor_nd_user' => ['nullable', 'string', Rule::unique('rendans', 'nomor_nd_user')],
            'tanggal_nd_user' => ['nullable', 'date'],
            'dokumen_nd_user' => ['nullable', 'string'],

            // RAB Field
            'rab' => ['nullable', 'numeric'],

            // RKS Fields
            'nomor_rks' => ['nullable', 'string'],
            'tanggal_rks' => ['nullable', 'date'],
            'dokumen_rks' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $rendanData = $validated;

            $req = Rendan::create($rendanData);

            DB::commit();

            return redirect()
                ->route('admin.paket.show', $req->enjiniring->paket->id)
                ->with('success', 'Data Rendan berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();
            return redirect()->back()->withInput()->with('error', 'Gagal menyimpan data Rendan: ' . $e->getMessage());
        }
    }

    // --- UPDATE METHOD (Edit Data) ---
    public function update(Request $request, $id)
    {
        $rendan = Rendan::findOrFail($id);

        // 1. Tentukan aturan validasi
        $validated = $request->validate([
            'enjiniring_id' => ['required', 'exists:enjinirings,id'],

            // ND User Fields
            'nomor_nd_user' => [
                'nullable',
                'string',
                Rule::unique('rendans', 'nomor_nd_user')->ignore($rendan->id)
            ],
            'tanggal_nd_user' => ['nullable', 'date'],
            'dokumen_nd_user' => ['nullable', 'string'],

            // RAB Field
            'rab' => ['nullable', 'numeric'],

            // RKS Fields
            'nomor_rks' => ['nullable', 'string'],
            'tanggal_rks' => ['nullable', 'date'],
            'dokumen_rks' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $rendanData = $validated;

            $rendan->update($rendanData);

            DB::commit();

            return redirect()
                ->route('admin.paket.show', $rendan->enjiniring->paket->id)
                ->with('success', 'Data Rendan berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();

            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Rendan: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Rendan::findOrFail($id);
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
