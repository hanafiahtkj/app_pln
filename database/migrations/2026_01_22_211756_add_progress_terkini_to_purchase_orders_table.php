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
        Schema::table('purchase_orders', function (Blueprint $table) {
            /** * Menggunakan decimal(5,2) agar bisa menyimpan angka 100.00
             * Default 0 agar tidak kosong saat baru dibuat.
             * Diletakkan setelah kolom ba_stap agar urutannya rapi.
             */
            $table->decimal('progress_terkini', 5, 2)->default(0)->after('ba_stap')->comment('Progress dalam persen (Cth: 25.50)');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->dropColumn('progress_terkini');
        });
    }
};
