<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Pembayaran extends Model
{
   use HasFactory;

   use HasUlids;

   protected $guarded = ['id', 'created_at', 'updated_at'];

   protected $appends = ['is_completed'];

   public function kontrak(): BelongsTo
   {
        return $this->belongsTo(Kontrak::class);
   }

   public function getIsCompletedAttribute()
    {
        return ($this->nilai_tagihan > 0) &&
            ($this->nilai_bayar_vendor > 0) &&
            ($this->nilai_bayar_pajak > 0) &&
            !empty($this->realisasi_bayar) &&
            !empty($this->realisasi_bayar_pajak);
    }
}
