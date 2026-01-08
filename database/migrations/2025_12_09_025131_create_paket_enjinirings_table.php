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
        Schema::create('enjinirings', function (Blueprint $table) {
            // Menggunakan ULID sebagai Primary Key
            $table->ulid('id')->primary();

            // Foreign Key ke tabel 'pakets'
            // Asumsi: Tabel 'pakets' menggunakan ULID sebagai primary key (karena Model Paket Anda menggunakan HasUlids)
            $table->foreignUlid('paket_id')
                  ->constrained('pakets') // Relasi ke tabel 'pakets'
                  ->onDelete('cascade');  // Jika Paket dihapus, data enjiniring ikut terhapus

            // --- Kolom-kolom untuk Tracking Enjiniring (sesuai data sheet 'engineering.xlsx') ---
            $table->date('target_survey')->nullable();
            $table->date('realisasi_survey')->nullable();
            $table->string('dokumen_survey', 255)->nullable(); // Path/Nama dokumen Survey

            $table->date('target_dokumen_enjiniring')->nullable();
            $table->date('realisasi_dokumen_enjiniring')->nullable();

            $table->string('dokumen_rab', 255)->nullable(); // Path/Nama dokumen RAB
            $table->string('dokumen_tor', 255)->nullable(); // Path/Nama dokumen TOR

            $table->text('keterangan')->nullable(); // Keterangan tambahan

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('enjinirings');
    }
};
