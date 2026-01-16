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
            $table->decimal('rab', 15, 2)->nullable()->after('dokumen_rab');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('enjinirings', function (Blueprint $table) {
            $table->dropColumn('rab');
        });
    }
};
