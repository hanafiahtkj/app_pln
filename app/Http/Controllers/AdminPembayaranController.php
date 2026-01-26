<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use App\Models\Kontrak; // Model untuk relasi (Foreign Key)
use App\Models\Pembayaran; // Model utama (Pembayaran)
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Exception;
use App\Services\DataTablePaginationService;

class AdminPembayaranController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-pembayaran');
    }

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
            'bulan_tahun_akb' => ['nullable', 'date'],
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
        $perPage = $this->pagination->resolvePerPageWithDefaults($request);

        // Ambil status filter dari request, default-kan ke 'belum_diproses' jika tidak ada filter lain
        $tahunFilter = $request->query('tahun') ?? date('Y');
        $statusFilter = $request->input('filter_status', 'semua');

        $query = Paket::latest()->with([
            'unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ]);

        $user = auth()->user();

        // Filter berdasarkan unit user
        if (!$user->hasRole('superuser') && $user->unit_id != 1) {
            $query->where('unit_id', $user->unit_id);
        }

        if ($tahunFilter !== 'semua') {
            $query->where('tahun', $tahunFilter);
        }

        // LOGIKA FILTER BARU
        if ($statusFilter === 'belum_diproses') {
            $query->whereHas('enjiniring.rendan.lakdan.kontrak', function ($q) {
                $q->completed();
            });
            $query->whereDoesntHave('enjiniring.rendan.lakdan.kontrak.pembayaran');
        } elseif ($statusFilter === 'proses') {
            $query->has('enjiniring.rendan.lakdan.kontrak.pembayaran');
        }
        else {
            $query->whereHas('enjiniring.rendan.lakdan.kontrak', function ($q) {
                $q->completed();
            });
        }

        $data = $query->paginate($perPage)->withQueryString();

        return Inertia::render('Admin/Pembayaran/IndexPage', [
            'data' => $data,
            'filters' => [
                'status' => $statusFilter,
                'tahun' => $tahunFilter,
            ]
        ]);
    }

    /**
     * Tampilkan form untuk membuat Pembayaran baru.
     */
    public function create()
    {
        $kontraks = Kontrak::with('lakdan.rendan.enjiniring.paket.prk')
            ->get();

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
        // Dapatkan ID Kontrak yang saat ini terkait dengan PO ini.
        $currentKontrakId = $pembayaran->kontrak_id;

        // 2. Query untuk mengambil daftar Kontrak yang tersedia:
        $kontraks = Kontrak::with('lakdan.rendan.enjiniring.paket.prk') // Tambahkan relasi yang dibutuhkan untuk modal
            ->where(function ($query) use ($currentKontrakId) {
                $query->where('id', $currentKontrakId);
            })
            ->get();

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
            $req = Pembayaran::create($validated);

            DB::commit();

            return redirect()
                ->route('admin.pembayaran.show', $req->kontrak->lakdan->rendan->enjiniring->paket->id)
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
                ->route('admin.pembayaran.show', $pembayaran->kontrak->lakdan->rendan->enjiniring->paket->id)
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
            $data = Pembayaran::where('kontrak_id', $id);

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

    public function show($id)
    {
        $paket = Paket::with([
            'unit',
            'prk.unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ])->findOrFail($id);

        return Inertia::render('Admin/Pembayaran/ShowPage', [
            'data' => $paket,
        ]);
    }
}
