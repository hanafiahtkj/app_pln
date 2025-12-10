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
        Schema::create('pakets', function (Blueprint $table) {
            $table->ulid('id')->primary();

            // Kolom Relasi (Foreign Key)
            // Menggunakan foreignId() untuk Laravel 8+ dan constraint index ke tabel 'prks'
            $table->foreignUlid('prk_id')
                  ->constrained('prks') // Relasi ke tabel 'prks' (Primary Key id)
                  ->onDelete('cascade'); // Jika PRK dihapus, paket terkait ikut terhapus

            // Informasi Pokok Paket
            $table->integer('tahun')->nullable();

            // Informasi SKK (Surat Keputusan Kebutuhan)
            $table->string('dokumen_skk')->nullable();
            $table->string('nomor_skk')->unique()->nullable();
            $table->date('tanggal_skk')->nullable();
            $table->double('nilai_skk', 15, 4)->nullable();
            $table->string('status_paket')->nullable(); // Cth: Penetapan, Indikatif

            $table->timestamps();
        });
    }

    /**
     * Batalkan migrasi.
     */
    public function down(): void
    {
        Schema::dropIfExists('pakets');
    }
};
