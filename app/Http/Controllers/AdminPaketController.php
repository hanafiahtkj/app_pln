<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use App\Models\Unit;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use App\Models\Prk;
use App\Services\DataTablePaginationService;

class AdminPaketController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-paket');
    }

    public function index(Request $request)
    {
        $perPage = $this->pagination->resolvePerPageWithDefaults($request);

        $tahunFilter = $request->query('tahun') ?? date('Y');

        // 1. Inisialisasi query dasar dengan eager loading relasi prk
        $query = Paket::latest()->with([
            'unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ]);

        $user = auth()->user();

        // 2. Filter berdasarkan unit_id yang ada di tabel PRK
        if (!$user->hasRole('superuser') && $user->unit_id != 1) {
            $query->where('unit_id', $user->unit_id);
        }

        if ($tahunFilter !== 'semua') {
            $query->where('tahun', $tahunFilter);
        }

        // 3. Eksekusi pagination
        $data = $query->paginate($perPage);

        return Inertia::render('Admin/Paket/IndexPage', [
            'data' => $data,
            'filters' => [
                'tahun' => $tahunFilter,
            ]
        ]);
    }

    public function show($id)
    {
        $paket = Paket::with([
            'unit',
            'prk.unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ])->findOrFail($id);

        return Inertia::render('Admin/Paket/ShowPage', [
            'data' => $paket,
        ]);
    }

    public function create()
    {
        // $this->authorize('create-lapangan');

        return Inertia::render('Admin/Paket/CreatePage', [
            'prks' => Prk::latest()->get(),
            'units' => [
                'data' => Unit::select(['id', 'kode', 'name'])->get(),
            ],
        ]);
    }

    public function store(Request $request)
    {
        // 1. Tentukan aturan validasi sesuai skema tabel `pakets`
        $validated = $request->validate([
            'prk_id' => ['required', 'exists:prks,id'], // Foreign Key ke tabel prks
            'tahun' => ['required', 'integer', 'digits:4'],
            'uraian_paket' => ['required', 'string'],
            'unit_id' => ['required', 'exists:units,id'],
            // SKK Fields
            'nomor_skk' => ['required', 'string', Rule::unique('pakets', 'nomor_skk')], // Nomor SKK harus unik
            'tanggal_skk' => ['nullable', 'date'],
            'nilai_skk' => ['nullable', 'numeric'],
            'status_paket' => ['nullable', 'string'],

            // Dokumen SKK (File Upload dari pre-upload asinkron)
            'dokumen_skk' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $paketData = $validated;

            $req = Paket::create($paketData);

            DB::commit();

            return redirect()
                ->route('admin.paket.show', $req->id)
                ->with('success', 'Data Paket dan dokumen SKK berhasil ditambahkan.');

        } catch (\Exception $e) {
            DB::rollBack();

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
            'prks' => Prk::latest()->get(),
            'units' => [
                'data' => Unit::select(['id', 'kode', 'name'])->get(),
            ],
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
            'uraian_paket' => ['required', 'string'],
            'unit_id' => ['required', 'exists:units,id'],
            // SKK Fields
            // Abaikan Nomor SKK saat ini untuk validasi unique
            'nomor_skk' => ['required', 'string', Rule::unique('pakets', 'nomor_skk')->ignore($paket->id)],
            'tanggal_skk' => ['nullable', 'date'],
            'nilai_skk' => ['nullable', 'numeric'],
            'status_paket' => ['nullable', 'string'],

            // Dokumen SKK (Path & Name dari pre-upload asinkron)
            'dokumen_skk' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $paketData = $validated;

            $paket->update($paketData);

            DB::commit();

            return redirect()
                ->route('admin.paket.show', $paket->id)
                ->with('success', 'Data Paket dan dokumen SKK berhasil diperbarui.');

        } catch (\Exception $e) {
            DB::rollBack();

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
