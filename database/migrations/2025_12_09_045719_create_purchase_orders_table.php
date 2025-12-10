<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Jalankan migrasi.
     */
    public function up(): void
    {
        // Membuat tabel untuk Purchase Order dan Pelacakan Progres (PO)
        Schema::create('purchase_orders', function (Blueprint $table) {
            $table->ulid('id')->primary();

            // Kunci Asing ke tabel Kontrak (Kontrak yang terkait dengan PO ini)
            // Asumsi tabel 'kontraks' sudah ada dari langkah sebelumnya
            $table->foreignUlid('kontrak_id')
                  ->constrained('kontraks')
                  ->onDelete('cascade');

            // --- Bagian Purchase Order (PO) ---
            $table->date('rencana_po')->nullable();
            $table->date('realisasi_po')->nullable();
            $table->string('dokumen_po')->nullable(); // Dokumen PO

            // --- Bagian Mobilisasi (MOS) ---
            $table->date('rencana_mos')->nullable();
            $table->date('realisasi_mos')->nullable();
            $table->string('dokumen_pemeriksaan_mos')->nullable(); // Dokumen Pemeriksaan MOS

            // --- Bagian Progress 25% ---
            $table->date('rencana_progress_25')->nullable();
            $table->date('realisasi_progress_25')->nullable();
            $table->string('ba_pemeriksaan_25')->nullable(); // BA Pemeriksaan Progress 25%

            // --- Bagian Progress 50% ---
            $table->date('rencana_progress_50')->nullable();
            $table->date('realisasi_progress_50')->nullable();
            $table->string('ba_pemeriksaan_50')->nullable(); // BA Pemeriksaan Progress 50%

            // --- Bagian Progress 75% ---
            $table->date('rencana_progress_75')->nullable();
            $table->date('realisasi_progress_75')->nullable();
            $table->string('ba_pemeriksaan_75')->nullable(); // BA Pemeriksaan Progress 75%

            // --- Bagian COD (Commercial Operation Date) ---
            $table->date('rencana_cod')->nullable();
            $table->date('realisasi_cod')->nullable();
            $table->string('ba_stp')->nullable(); // Berita Acara Serah Terima Pekerjaan (STP)
            $table->string('ba_stap')->nullable(); // Berita Acara Serah Terima Aset (STAP)

            // --- Keterangan ---
            $table->text('keterangan')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Balikkan migrasi.
     */
    public function down(): void
    {
        Schema::dropIfExists('purchase_orders');
    }
};
