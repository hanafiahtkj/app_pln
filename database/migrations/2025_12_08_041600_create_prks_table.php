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
        Schema::create('prks', function (Blueprint $table) {
            $table->ulid('id')->primary();

            // --- Kolom Data Utama ---
            $table->year('tahun')->nullable();
            $table->string('prk', 50)->unique();
            $table->string('fungsi', 100)->nullable();
            $table->text('uraian')->nullable();
            $table->string('status', 50)->nullable();

            $table->foreignUlid('user_id')->nullable();
            $table->foreignId('unit_id')->nullable();
            $table->foreignId('bidang_id')->nullable();

            // Kolom Keuangan
            $table->decimal('ai_rupiah', 16, 4)->nullable();


            // --- Kolom Dokumen dan Tanggal Penting ---
            $table->string('dokumen_kkp', 255)->nullable();
            $table->date('tanggal_kkp')->nullable();

            $table->string('ulasan_kajian_risiko', 255)->nullable();
            $table->date('tanggal_ulasan_kajian_risiko')->nullable();

            $table->string('dokumen_grc', 255)->nullable();
            $table->date('tanggal_dokumen_grc')->nullable();

            $table->date('tanggal_tvv')->nullable();
            $table->string('status_persetujuan_tvv', 100)->nullable();
            $table->string('dokumen_tvv', 255)->nullable();

            // --- Kolom SKAI ---
            $table->string('dokumen_skai', 255)->nullable();
            $table->string('nomor_skai', 255)->nullable();
            $table->date('tanggal_skai')->nullable();
            $table->decimal('nilai_skai', 16, 4)->nullable();

            $table->unsignedSmallInteger('jumlah_paket')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Balikkan migrasi.
     */
    public function down(): void
    {
        Schema::dropIfExists('prks');
    }
};
