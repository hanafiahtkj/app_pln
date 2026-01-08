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
        Schema::create('units', function (Blueprint $table) {
            $table->id(); // Kolom ID (Primary Key, Auto-increment)
            $table->string('name', 150)->unique(); // Nama Unit, harus unik
            $table->timestamps();
        });
    }

    /**
     * Balikkan migrasi.
     */
    public function down(): void
    {
        Schema::dropIfExists('units');
    }
};
