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
        Schema::table('rendans', function (Blueprint $table) {
            Schema::table('rendans', function (Blueprint $table) {
            // Nilai HPE (Rupiah) - menggunakan decimal untuk akurasi keuangan
            $table->decimal('nilai_hpe', 15, 2)->nullable()->after('rab');

            // Dokumen HPE (Nama file/path)
            $table->string('dokumen_hpe')->nullable()->after('nilai_hpe');

            // Target Tanggal RKS
            $table->date('target_tanggal_rks')->nullable()->after('tanggal_rks');
        });
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('rendans', function (Blueprint $table) {
            $table->dropColumn(['nilai_hpe', 'dokumen_hpe', 'target_tanggal_rks']);
        });
    }
};
