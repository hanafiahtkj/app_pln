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
        Schema::create('pembayarans', function (Blueprint $table) {
            $table->ulid('id')->primary();

            // Foreign Key to Kontrak (dihubungkan melalui Nomor Perjanjian)
            $table->foreignUlid('kontrak_id')->constrained('kontraks')->cascadeOnDelete();

            // Detail Pembayaran
            $table->string('termin_pembayaran'); // Cth: Termin #1
            $table->decimal('denda', 15, 2)->nullable();

            // Nilai
            $table->decimal('nilai_tagihan', 15, 2)->nullable();
            $table->decimal('nilai_akb', 15, 2)->nullable();
            $table->decimal('nilai_ppn', 15, 2)->nullable();
            $table->decimal('nilai_pph', 15, 2)->nullable();
            $table->decimal('nilai_bayar_vendor', 15, 2)->nullable();
            $table->decimal('nilai_bayar_pajak', 15, 2)->nullable();

            // Tanggal Pembayaran Vendor
            $table->date('rencana_bayar')->nullable();
            $table->date('realisasi_bayar')->nullable();

            // Tanggal Pembayaran Pajak
            $table->date('rencana_bayar_pajak')->nullable();
            $table->date('realisasi_bayar_pajak')->nullable();

            // Status Checklist (Boolean)
            $table->string('sub_id')->nullable();
            $table->boolean('berkas')->default(false);
            $table->boolean('vendor_upload_vip')->default(false);
            $table->boolean('maker')->default(false);
            $table->boolean('checker')->default(false);
            $table->boolean('tax')->default(false);
            $table->boolean('sptjp')->default(false);
            $table->boolean('ira_irs')->default(false);
            $table->boolean('verifikator_pusat')->default(false);
            $table->boolean('lunas_vendor')->default(false);
            $table->boolean('lunas_pajak')->default(false);

            // Lain-lain
            $table->text('keterangan')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pembayarans');
    }
};
