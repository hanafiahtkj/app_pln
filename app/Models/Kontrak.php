<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Kontrak extends Model
{
   use HasFactory;

   use HasUlids;

   protected $guarded = ['id', 'created_at', 'updated_at'];

   public function lakdan(): BelongsTo
   {
        return $this->belongsTo(Lakdan::class);
   }

   public function purchase_order()
    {
        return $this->hasOne(PurchaseOrder::class, 'kontrak_id');
    }

    public function pembayaran()
    {
        return $this->hasMany(Pembayaran::class, 'kontrak_id');
    }
}
