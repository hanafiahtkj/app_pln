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

   protected $appends = ['is_completed'];

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

    public function getIsCompletedAttribute()
    {
        return !empty($this->nomor_perjanjian) &&
            ($this->nilai_perjanjian_ppn > 0) &&
            !empty($this->realisasi_tanggal_perjanjian) &&
            !empty($this->tanggal_berakhir) &&
            !empty($this->tanggal_efektif) &&
            ($this->nilai_jaminan_pelaksanaan > 0) &&
            !empty($this->realisasi_jaminan_pelaksanaan);
    }

    public function scopeCompleted($query)
    {
        return $query->whereNotNull('nomor_perjanjian')
            ->where('nomor_perjanjian', '!=', '')
            ->where('nilai_perjanjian_ppn', '>', 0)
            ->whereNotNull('realisasi_tanggal_perjanjian')
            ->whereNotNull('tanggal_berakhir')
            ->whereNotNull('tanggal_efektif')
            ->where('nilai_jaminan_pelaksanaan', '>', 0)
            ->whereNotNull('realisasi_jaminan_pelaksanaan');
    }
}
