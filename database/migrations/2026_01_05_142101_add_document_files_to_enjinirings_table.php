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
        Schema::table('enjinirings', function (Blueprint $table) {
            $table->string('file_survey', 255)->nullable()->after('realisasi_survey');
            $table->string('file_rab', 255)->nullable()->after('realisasi_dokumen_enjiniring');
            $table->string('file_tor', 255)->nullable()->after('dokumen_rab');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('enjinirings', function (Blueprint $table) {
            $table->dropColumn(['file_survey', 'file_rab', 'file_tor']);
        });
    }
};
