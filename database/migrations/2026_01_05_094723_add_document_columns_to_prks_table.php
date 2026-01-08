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
        Schema::table('prks', function (Blueprint $table) {
            // Kolom Baru untuk KKP
            $table->string('file_kkp', 255)->nullable()->after('tanggal_kkp');

            // Kolom Baru untuk Kajian Risiko
            $table->string('file_kajian_risiko', 255)->nullable()->after('tanggal_ulasan_kajian_risiko');

            // Kolom Baru untuk GRC
            $table->string('file_grc', 255)->nullable()->after('tanggal_dokumen_grc');

            // Kolom Baru untuk TVV
            $table->string('file_tvv', 255)->nullable()->after('dokumen_tvv');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('prks', function (Blueprint $table) {
            $table->dropColumn([
                'file_kkp',
                'file_kajian_risiko',
                'file_grc',
                'file_tvv',
            ]);
        });
    }
};
