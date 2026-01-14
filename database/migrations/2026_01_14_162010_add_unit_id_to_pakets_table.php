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
        Schema::table('pakets', function (Blueprint $table) {
            // Letakkan setelah kolom prk_id agar struktur tabel rapi
            $table->foreignId('unit_id')
                ->after('prk_id')
                ->nullable() // Gunakan nullable jika data lama belum punya unit_id
                ->constrained('units')
                ->onDelete('set null'); // Atau 'cascade' tergantung kebutuhan bisnis
        });
    }

    public function down(): void
    {
        Schema::table('pakets', function (Blueprint $table) {
            $table->dropForeign(['unit_id']);
            $table->dropColumn('unit_id');
        });
    }
};
