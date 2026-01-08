<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('lakdans', function (Blueprint $table) {
            // Persiapan pengadaan
            $table->date('rencana_persiapan_pengadaan')->nullable();
            $table->date('realisasi_persiapan_pengadaan')->nullable();
            $table->string('persiapan_pengadaan')->nullable();

            // Pengumuman pengadaan
            $table->date('rencana_pengumuman_pengadaan')->nullable();
            $table->date('realisasi_pengumuman_pengadaan')->nullable();
            $table->string('pengumuman_pengadaan')->nullable();

            // Pendaftaran & Pengambilan Dokumen Tender / RKS
            $table->date('rencana_pendaftaran_ambil_dokumen')->nullable();
            $table->date('realisasi_pendaftaran_ambil_dokumen')->nullable();
            $table->string('pendaftaran_ambil_dokumen')->nullable();

            // Aanwijzing
            $table->date('rencana_aanwijzing')->nullable();
            $table->date('realisasi_aanwijzing')->nullable();
            $table->string('aanwijzing')->nullable();

            // Pemasukan Dokumen Penawaran
            $table->date('rencana_pemasukan_penawaran')->nullable();
            $table->date('realisasi_pemasukan_penawaran')->nullable();
            $table->string('pemasukan_penawaran')->nullable();

            // Pembukaan Dokumen dan Evaluasi
            $table->date('rencana_pembukaan_evaluasi')->nullable();
            $table->date('realisasi_pembukaan_evaluasi')->nullable();
            $table->string('pembukaan_evaluasi')->nullable();

            // Klarifikasi dan Negosiasi Harga
            $table->date('rencana_klarifikasi_negosiasi')->nullable();
            $table->date('realisasi_klarifikasi_negosiasi')->nullable();
            $table->string('klarifikasi_negosiasi')->nullable();

            // Usulan Penetapan Pemenang
            $table->date('rencana_usulan_penetapan_pemenang')->nullable();
            $table->date('realisasi_usulan_penetapan_pemenang')->nullable();
            $table->string('usulan_penetapan_pemenang')->nullable();

            // Izin Prinsip Tanda Tangan Kontrak
            $table->date('rencana_izin_prinsip_kontrak')->nullable();
            $table->date('realisasi_izin_prinsip_kontrak')->nullable();
            $table->string('izin_prinsip_kontrak')->nullable();

            // Penetapan dan Pengumuman Pemenang
            $table->date('rencana_penetapan_pengumuman_pemenang')->nullable();
            $table->date('realisasi_penetapan_pengumuman_pemenang')->nullable();
            $table->string('penetapan_pengumuman_pemenang')->nullable();

            // Sanggah
            $table->date('rencana_sanggah')->nullable();
            $table->date('realisasi_sanggah')->nullable();
            $table->string('sanggah')->nullable();

            // Penunjukan Penyedia Barang/Jasa
            $table->date('rencana_penunjukan_penyedia')->nullable();
            $table->date('realisasi_penunjukan_penyedia')->nullable();
            $table->string('penunjukan_penyedia')->nullable();
            $table->string('dokumen_penunjukan_penyedia')->nullable();

            // Contract Discussion Agreement (CDA)
            $table->date('rencana_cda')->nullable();
            $table->date('realisasi_cda')->nullable();
            $table->string('cda')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('lakdans', function (Blueprint $table) {
            $table->dropColumn([
                'rencana_persiapan_pengadaan', 'realisasi_persiapan_pengadaan', 'persiapan_pengadaan',
                'rencana_pengumuman_pengadaan', 'realisasi_pengumuman_pengadaan', 'pengumuman_pengadaan',
                'rencana_pendaftaran_ambil_dokumen', 'realisasi_pendaftaran_ambil_dokumen', 'pendaftaran_ambil_dokumen',
                'rencana_aanwijzing', 'realisasi_aanwijzing', 'aanwijzing',
                'rencana_pemasukan_penawaran', 'realisasi_pemasukan_penawaran', 'pemasukan_penawaran',
                'rencana_pembukaan_evaluasi', 'realisasi_pembukaan_evaluasi', 'pembukaan_evaluasi',
                'rencana_klarifikasi_negosiasi', 'realisasi_klarifikasi_negosiasi', 'klarifikasi_negosiasi',
                'rencana_usulan_penetapan_pemenang', 'realisasi_usulan_penetapan_pemenang', 'usulan_penetapan_pemenang',
                'rencana_izin_prinsip_kontrak', 'realisasi_izin_prinsip_kontrak', 'izin_prinsip_kontrak',
                'rencana_penetapan_pengumuman_pemenang', 'realisasi_penetapan_pengumuman_pemenang', 'penetapan_pengumuman_pemenang',
                'rencana_sanggah', 'realisasi_sanggah', 'sanggah',
                'rencana_penunjukan_penyedia', 'realisasi_penunjukan_penyedia', 'penunjukan_penyedia',
                'rencana_cda', 'realisasi_cda', 'cda'
            ]);
        });
    }
};
