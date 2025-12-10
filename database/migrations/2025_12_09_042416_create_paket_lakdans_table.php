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
        // Nama tabel: lakdans (Pelaksanaan Pengadaan)
        Schema::create('lakdans', function (Blueprint $table) {
            $table->ulid('id')->primary();

            // Foreign Key ke tabel rendans (Rencana Pengadaan)
            $table->foreignUlid('rendan_id')->constrained('rendans')->cascadeOnDelete();

            $table->string('proses_pengadaan')->nullable();
            $table->string('metode_pengadaan')->nullable();

            // HPS (Harga Perkiraan Sendiri)
            $table->date('rencana_tanggal_hps')->nullable();
            $table->date('realisasi_tanggal_hps')->nullable();
            $table->string('dokumen_hps')->nullable(); // Path file dokumen HPS
            $table->string('nomor_hps')->nullable();
            $table->decimal('nilai_hps', 15, 4)->nullable(); // Nilai HPS

            // Pengumuman Lelang/Tender
            $table->date('rencana_pengumuman_lelang')->nullable();
            $table->date('realisasi_pengumuman_lelang')->nullable();
            $table->string('nomor_pengumuman_lelang')->nullable();

            // Penunjukan Pemenang
            $table->string('dokumen_penunjukan_pemenang')->nullable(); // Path file dokumen penunjukan pemenang
            $table->date('rencana_penunjukan_pemenang')->nullable();
            $table->date('realisasi_penunjukan_pemenang')->nullable();
            $table->string('nomor_penunjukan_pemenang')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('lakdans');
    }
};
