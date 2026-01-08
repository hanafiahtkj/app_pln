<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Enjiniring extends Model
{
   use HasFactory;

   use HasUlids;

   protected $guarded = ['id', 'created_at', 'updated_at'];

   public function paket(): BelongsTo
    {
        return $this->belongsTo(Paket::class);
    }

    public function rendan()
    {
        return $this->hasOne(Rendan::class, 'enjiniring_id');
    }
}
