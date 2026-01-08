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
            // Menambahkan BA Pembayaran untuk Progress 25%
            $table->string('ba_pembayaran_25')
                  ->nullable()
                  ->after('ba_pemeriksaan_25')
                  ->comment('BA Pembayaran Progress 25%');

            // Menambahkan BA Pembayaran untuk Progress 50%
            $table->string('ba_pembayaran_50')
                  ->nullable()
                  ->after('ba_pemeriksaan_50')
                  ->comment('BA Pembayaran Progress 50%');

            // Menambahkan BA Pembayaran untuk Progress 75%
            $table->string('ba_pembayaran_75')
                  ->nullable()
                  ->after('ba_pemeriksaan_75')
                  ->comment('BA Pembayaran Progress 75%');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->dropColumn([
                'ba_pembayaran_25',
                'ba_pembayaran_50',
                'ba_pembayaran_75'
            ]);
        });
    }
};
