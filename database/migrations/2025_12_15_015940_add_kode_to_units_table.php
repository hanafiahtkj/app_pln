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
        Schema::table('units', function (Blueprint $table) {
            // Tambahkan kolom 'kode' setelah kolom 'id'
            $table->string('kode', 20)->unique()->nullable()->after('id');
        });
    }

    /**
     * Balikkan migrasi.
     */
    public function down(): void
    {
        Schema::table('units', function (Blueprint $table) {
            // Hapus kolom 'kode'
            $table->dropColumn('kode');
        });
    }
};
