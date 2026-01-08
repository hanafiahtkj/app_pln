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
        Schema::table('users', function (Blueprint $table) {
            // Tambahkan kolom foreign key 'unit_id'
            // Merujuk ke tabel 'units'
            $table->foreignId('unit_id')
                  ->nullable() // Atur agar kolom ini boleh kosong
                  ->after('email') // Letakkan setelah kolom 'email' (opsional)
                  ->constrained('units')
                  ->onDelete('set null'); // Jika unit dihapus, set nilai unit_id di user menjadi NULL (opsional)
        });
    }

    /**
     * Balikkan migrasi.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Hapus foreign key sebelum menghapus kolom itu sendiri
            $table->dropConstrainedForeignId('unit_id');

            // Hapus kolom 'unit_id'
            $table->dropColumn('unit_id');
        });
    }
};
