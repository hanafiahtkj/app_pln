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

            Schema::create('rendans', function (Blueprint $table) {
                $table->ulid('id')->primary();

                // Relasi ke PRK
                // PENTING: Tabel 'prks' harus ada.
                $table->foreignUlid('prk_id')->index()->comment('Foreign Key ke tabel prks');

                // Kolom-kolom berdasarkan 'rendan.xlsx - Sheet1.csv' yang tersisa

                // Dokumen ND User
                $table->string('dokumen_nd_user')->nullable(); // Dokumen ND User
                $table->string('nomor_nd_user')->nullable(); // Nomor ND User
                $table->date('tanggal_nd_user')->nullable(); // Tanggal ND User

                // RAB
                $table->string('rab')->nullable(); // RAB (Nilai/Status)

                // Dokumen RKS
                $table->string('dokumen_rks')->nullable(); // Dokumen RKS
                $table->string('nomor_rks')->nullable(); // Nomor RKS
                $table->date('tanggal_rks')->nullable(); // Tanggal RKS

                $table->timestamps();

                // Definisi Foreign Key
                $table->foreign('prk_id')->references('id')->on('prks')->onDelete('cascade');
            });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rendans');
    }
};
