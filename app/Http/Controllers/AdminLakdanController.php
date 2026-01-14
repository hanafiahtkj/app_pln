<?php

namespace App\Http\Controllers;

use App\Models\Paket;
use App\Models\Rendan; // Tetap digunakan untuk relasi
use App\Models\Lakdan; // Model baru untuk Lakdan (Pelaksanaan Pengadaan)
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Exception;
use App\Services\DataTablePaginationService;

class AdminLakdanController extends Controller
{
    public function __construct(private DataTablePaginationService $pagination)
    {
        $this->middleware('permission:manage-lakdan');
    }

    /**
     * Tampilkan daftar data Lakdan.
     */
    public function index(Request $request)
    {
        $perPage = $this->pagination->resolvePerPageWithDefaults($request);

        // Ambil status filter dari request, default-kan ke 'belum_diproses' jika tidak ada filter lain
        $statusFilter = $request->input('filter_status', 'belum_diproses');

        $query = Paket::latest()->with([
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ]);

        $user = auth()->user();

        // Filter berdasarkan unit user
        if ($user->hasRole('user')) {
            $query->whereHas('prk', function ($q) use ($user) {
                $q->where('unit_id', $user->unit_id);
            });
        }

        // LOGIKA FILTER BARU
        if ($statusFilter === 'belum_diproses') {
            $query->has('enjiniring.rendan');
            $query->whereDoesntHave('enjiniring.rendan.lakdan');
        } elseif ($statusFilter === 'proses') {
            $query->has('enjiniring.rendan.lakdan');
        }

        $data = $query->paginate($perPage)->withQueryString();

        return Inertia::render('Admin/Lakdan/IndexPage', [
            'data' => $data,
            'filters' => [
                'status' => $statusFilter
            ]
        ]);
    }

    /**
     * Tampilkan form untuk membuat Lakdan baru.
     */
    public function create()
    {
        // Menyediakan daftar Rendan untuk dipilih sebagai foreign key
        $rendans = Rendan::with('enjiniring.paket.prk')
            ->doesntHave('lakdan')
            ->get();

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

        $currentRendanId = $lakdan->rendan_id;

        $rendans = Rendan::with('enjiniring.paket.prk')
            ->where(function ($query) use ($currentRendanId) {
                $query->doesntHave('lakdan');
                $query->orWhere('id', $currentRendanId);
            })
            ->get();


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
            'pic' => ['nullable', 'string'],
            'proses_pengadaan' => ['nullable', 'string'],
            'metode_pengadaan' => ['nullable', 'string'],

            // HPS Fields
            'rencana_tanggal_hps' => ['nullable', 'date'],
            'realisasi_tanggal_hps' => ['nullable', 'date'],
            'nomor_hps' => ['nullable', 'string'],
            'nilai_hps' => ['nullable', 'numeric'],
            'dokumen_hps' => ['nullable', 'string'],

            // Pengumuman Lelang Fields
            'rencana_pengumuman_lelang' => ['nullable', 'date'],
            'realisasi_pengumuman_lelang' => ['nullable', 'date'],
            'nomor_pengumuman_lelang' => ['nullable', 'string'],

            // Penunjukan Pemenang Fields
            'rencana_penunjukan_pemenang' => ['nullable', 'date'],
            'realisasi_penunjukan_pemenang' => ['nullable', 'date'],
            'nomor_penunjukan_pemenang' => ['nullable', 'string'],
            'dokumen_penunjukan_pemenang' => ['nullable', 'string'],

            // 1. Persiapan pengadaan
            'rencana_persiapan_pengadaan' => ['nullable', 'date'],
            'realisasi_persiapan_pengadaan' => ['nullable', 'date'],
            'persiapan_pengadaan' => ['nullable', 'string'],

            // 2. Pengumuman pengadaan
            'rencana_pengumuman_pengadaan' => ['nullable', 'date'],
            'realisasi_pengumuman_pengadaan' => ['nullable', 'date'],
            'pengumuman_pengadaan' => ['nullable', 'string'],

            // 3. Pendaftaran & Pengambilan Dokumen
            'rencana_pendaftaran_ambil_dokumen' => ['nullable', 'date'],
            'realisasi_pendaftaran_ambil_dokumen' => ['nullable', 'date'],
            'pendaftaran_ambil_dokumen' => ['nullable', 'string'],

            // 4. Aanwijzing
            'rencana_aanwijzing' => ['nullable', 'date'],
            'realisasi_aanwijzing' => ['nullable', 'date'],
            'aanwijzing' => ['nullable', 'string'],

            // 5. Pemasukan Dokumen Penawaran
            'rencana_pemasukan_penawaran' => ['nullable', 'date'],
            'realisasi_pemasukan_penawaran' => ['nullable', 'date'],
            'pemasukan_penawaran' => ['nullable', 'string'],

            // 6. Pembukaan Dokumen dan Evaluasi
            'rencana_pembukaan_evaluasi' => ['nullable', 'date'],
            'realisasi_pembukaan_evaluasi' => ['nullable', 'date'],
            'pembukaan_evaluasi' => ['nullable', 'string'],

            // 7. Klarifikasi dan Negosiasi Harga
            'rencana_klarifikasi_negosiasi' => ['nullable', 'date'],
            'realisasi_klarifikasi_negosiasi' => ['nullable', 'date'],
            'klarifikasi_negosiasi' => ['nullable', 'string'],

            // 8. Usulan Penetapan Pemenang
            'rencana_usulan_penetapan_pemenang' => ['nullable', 'date'],
            'realisasi_usulan_penetapan_pemenang' => ['nullable', 'date'],
            'usulan_penetapan_pemenang' => ['nullable', 'string'],

            // 9. Izin Prinsip Tanda Tangan Kontrak
            'rencana_izin_prinsip_kontrak' => ['nullable', 'date'],
            'realisasi_izin_prinsip_kontrak' => ['nullable', 'date'],
            'izin_prinsip_kontrak' => ['nullable', 'string'],

            // 10. Penetapan dan Pengumuman Pemenang
            'rencana_penetapan_pengumuman_pemenang' => ['nullable', 'date'],
            'realisasi_penetapan_pengumuman_pemenang' => ['nullable', 'date'],
            'penetapan_pengumuman_pemenang' => ['nullable', 'string'],

            // 11. Sanggah
            'rencana_sanggah' => ['nullable', 'date'],
            'realisasi_sanggah' => ['nullable', 'date'],
            'sanggah' => ['nullable', 'string'],

            // 12. Penunjukan Penyedia Barang/Jasa
            'rencana_penunjukan_penyedia' => ['nullable', 'date'],
            'realisasi_penunjukan_penyedia' => ['nullable', 'date'],
            'penunjukan_penyedia' => ['nullable', 'string'],
            'dokumen_penunjukan_penyedia' => ['nullable', 'string'],

            // 13. Contract Discussion Agreement (CDA)
            'rencana_cda' => ['nullable', 'date'],
            'realisasi_cda' => ['nullable', 'date'],
            'cda' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $lakdanData = $validated;

            $req = Lakdan::create($lakdanData);

            DB::commit();

            return redirect()
                ->route('admin.lakdan.show', $req->rendan->enjiniring->paket->id)
                ->with('success', 'Data Pelaksanaan Pengadaan berhasil ditambahkan.');

        } catch (Exception $e) {
            DB::rollBack();

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
            'pic' => ['nullable', 'string'],
            'proses_pengadaan' => ['nullable', 'string'],
            'metode_pengadaan' => ['nullable', 'string'],

            // HPS Fields
            'rencana_tanggal_hps' => ['nullable', 'date'],
            'realisasi_tanggal_hps' => ['nullable', 'date'],
            'nomor_hps' => ['nullable', 'string'],
            'nilai_hps' => ['nullable', 'numeric'],
            'dokumen_hps' => ['nullable', 'string'],

            // Pengumuman Lelang Fields
            'rencana_pengumuman_lelang' => ['nullable', 'date'],
            'realisasi_pengumuman_lelang' => ['nullable', 'date'],
            'nomor_pengumuman_lelang' => ['nullable', 'string'],

            // Penunjukan Pemenang Fields
            'rencana_penunjukan_pemenang' => ['nullable', 'date'],
            'realisasi_penunjukan_pemenang' => ['nullable', 'date'],
            'nomor_penunjukan_pemenang' => ['nullable', 'string'],
            'dokumen_penunjukan_pemenang' => ['nullable', 'string'],

            // 1. Persiapan pengadaan
            'rencana_persiapan_pengadaan' => ['nullable', 'date'],
            'realisasi_persiapan_pengadaan' => ['nullable', 'date'],
            'persiapan_pengadaan' => ['nullable', 'string'],

            // 2. Pengumuman pengadaan
            'rencana_pengumuman_pengadaan' => ['nullable', 'date'],
            'realisasi_pengumuman_pengadaan' => ['nullable', 'date'],
            'pengumuman_pengadaan' => ['nullable', 'string'],

            // 3. Pendaftaran & Pengambilan Dokumen
            'rencana_pendaftaran_ambil_dokumen' => ['nullable', 'date'],
            'realisasi_pendaftaran_ambil_dokumen' => ['nullable', 'date'],
            'pendaftaran_ambil_dokumen' => ['nullable', 'string'],

            // 4. Aanwijzing
            'rencana_aanwijzing' => ['nullable', 'date'],
            'realisasi_aanwijzing' => ['nullable', 'date'],
            'aanwijzing' => ['nullable', 'string'],

            // 5. Pemasukan Dokumen Penawaran
            'rencana_pemasukan_penawaran' => ['nullable', 'date'],
            'realisasi_pemasukan_penawaran' => ['nullable', 'date'],
            'pemasukan_penawaran' => ['nullable', 'string'],

            // 6. Pembukaan Dokumen dan Evaluasi
            'rencana_pembukaan_evaluasi' => ['nullable', 'date'],
            'realisasi_pembukaan_evaluasi' => ['nullable', 'date'],
            'pembukaan_evaluasi' => ['nullable', 'string'],

            // 7. Klarifikasi dan Negosiasi Harga
            'rencana_klarifikasi_negosiasi' => ['nullable', 'date'],
            'realisasi_klarifikasi_negosiasi' => ['nullable', 'date'],
            'klarifikasi_negosiasi' => ['nullable', 'string'],

            // 8. Usulan Penetapan Pemenang
            'rencana_usulan_penetapan_pemenang' => ['nullable', 'date'],
            'realisasi_usulan_penetapan_pemenang' => ['nullable', 'date'],
            'usulan_penetapan_pemenang' => ['nullable', 'string'],

            // 9. Izin Prinsip Tanda Tangan Kontrak
            'rencana_izin_prinsip_kontrak' => ['nullable', 'date'],
            'realisasi_izin_prinsip_kontrak' => ['nullable', 'date'],
            'izin_prinsip_kontrak' => ['nullable', 'string'],

            // 10. Penetapan dan Pengumuman Pemenang
            'rencana_penetapan_pengumuman_pemenang' => ['nullable', 'date'],
            'realisasi_penetapan_pengumuman_pemenang' => ['nullable', 'date'],
            'penetapan_pengumuman_pemenang' => ['nullable', 'string'],

            // 11. Sanggah
            'rencana_sanggah' => ['nullable', 'date'],
            'realisasi_sanggah' => ['nullable', 'date'],
            'sanggah' => ['nullable', 'string'],

            // 12. Penunjukan Penyedia Barang/Jasa
            'rencana_penunjukan_penyedia' => ['nullable', 'date'],
            'realisasi_penunjukan_penyedia' => ['nullable', 'date'],
            'penunjukan_penyedia' => ['nullable', 'string'],
            'dokumen_penunjukan_penyedia' => ['nullable', 'string'],

            // 13. Contract Discussion Agreement (CDA)
            'rencana_cda' => ['nullable', 'date'],
            'realisasi_cda' => ['nullable', 'date'],
            'cda' => ['nullable', 'string'],
        ]);

        try {
            DB::beginTransaction();

            $lakdanData = $validated;

            $lakdan->update($lakdanData);

            DB::commit();

            return redirect()
                ->route('admin.lakdan.show', $lakdan->rendan->enjiniring->paket->id)
                ->with('success', 'Data Pelaksanaan Pengadaan berhasil diperbarui.');

        } catch (Exception $e) {
            DB::rollBack();

            return redirect()->back()->withInput()->with('error', 'Gagal memperbarui data Pelaksanaan Pengadaan: ' . $e->getMessage());
        }
    }

    // --- DESTROY METHOD (Hapus Data) ---
    public function destroy($id)
    {
        try {
            DB::beginTransaction();
            $data = Lakdan::findOrFail($id);

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

    public function show($id)
    {
        $paket = Paket::with([
            'prk.unit',
            'prk.bidang',
            'enjiniring.rendan.lakdan.kontrak.purchase_order',
            'enjiniring.rendan.lakdan.kontrak.pembayaran'
        ])->findOrFail($id);

        return Inertia::render('Admin/Lakdan/ShowPage', [
            'data' => $paket,
        ]);
    }
}
