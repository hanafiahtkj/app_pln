<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('kontraks', function (Blueprint $table) {
            $table->ulid('id')->primary();

            // Foreign Key: Menghubungkan ke tabel 'lakdans' (Pelaksanaan Pengadaan)
            // Asumsi: Kontrak dibuat setelah Lakdan
            $table->foreignUlid('lakdan_id')->constrained()->onDelete('cascade');

            // --- Detail Perjanjian (Kontrak) ---
            $table->date('rencana_tanggal_perjanjian')->nullable();
            $table->date('realisasi_tanggal_perjanjian')->nullable();

            // Dokumen Perjanjian
            $table->string('dokumen_perjanjian', 255)->nullable()->comment('Path file dokumen');
            $table->string('dokumen_perjanjian_name', 255)->nullable()->comment('Nama asli file dokumen');
            $table->string('nomor_perjanjian', 255)->unique();

            // Nilai Moneter (Menggunakan Decimal 15,2 untuk mata uang Rupiah)
            $table->decimal('nilai_perjanjian_ppn', 15, 2)->nullable();
            $table->decimal('nilai_perjanjian_sebelum_ppn', 15, 2)->nullable();

            // --- Detail Pihak & Jenis ---
            $table->string('penyedia_barang_jasa', 255);
            $table->string('jenis_perjanjian', 50); // Cth: LUMSUM

            // --- Pelaksanaan & Durasi ---
            $table->unsignedSmallInteger('masa_pelaksanaan')->comment('Durasi masa pelaksanaan dalam hari');
            $table->date('tanggal_berakhir')->nullable();
            $table->unsignedSmallInteger('durasi_pengadaan')->comment('Durasi total pengadaan dalam hari');
            $table->string('status_proses', 50); // Cth: TERKONTRAK

            // --- Jaminan Pelaksanaan ---
            $table->date('rencana_jaminan_pelaksanaan')->nullable();
            $table->date('realisasi_jaminan_pelaksanaan')->nullable();

            // Dokumen Jaminan Pelaksanaan
            $table->string('dokumen_jaminan_pelaksanaan', 255)->nullable()->comment('Path file dokumen');
            $table->string('dokumen_jaminan_pelaksanaan_name', 255)->nullable()->comment('Nama asli file dokumen');

            $table->string('nomor_jaminan_pelaksanaan', 255)->nullable();
            $table->decimal('nilai_jaminan_pelaksanaan', 15, 2)->nullable();
            $table->string('bank_pemberi_jaminan', 100)->nullable();

            // --- Metrik & Risiko ---
            $table->string('tingkat_risiko_csms', 50)->nullable(); // Cth: Ekstrem
            $table->decimal('tkdn', 5, 2)->nullable()->comment('Tingkat Komponen Dalam Negeri (Format 5.00 untuk 5%)');
            $table->string('efisiensi_thd_hps', 50)->nullable()->comment('Disimpan sebagai string untuk menjaga format persentase (Cth: "1,36%")');

            // --- Lain-lain ---
            $table->text('keterangan')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('kontraks');
    }
};
