<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('lakdans', function (Blueprint $table) {
            // Menambahkan kolom pic setelah foreign key rendan_id
            $table->string('pic')->nullable()->after('rendan_id');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('lakdans', function (Blueprint $table) {
            $table->dropColumn('pic');
        });
    }
};
