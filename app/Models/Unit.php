<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Unit extends Model
{
   use HasFactory;

   protected $guarded = ['id', 'created_at', 'updated_at'];

   public function pakets(): HasMany
   {
        return $this->hasMany(Paket::class, 'unit_id');
   }
}
