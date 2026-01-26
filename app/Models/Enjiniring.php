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

   protected $appends = ['is_completed'];

   public function paket(): BelongsTo
    {
        return $this->belongsTo(Paket::class);
    }

    public function rendan()
    {
        return $this->hasOne(Rendan::class, 'enjiniring_id');
    }

    public function getIsCompletedAttribute()
    {
        return !empty($this->file_survey) &&
               !empty($this->realisasi_survey) &&
               !empty($this->realisasi_dokumen_enjiniring) &&
               ($this->rab > 0) &&
               !empty($this->file_rab) &&
               !empty($this->file_tor);
    }

    public function scopeCompleted($query)
    {
        return $query->whereNotNull('file_survey')
            ->where('file_survey', '!=', '')
            ->whereNotNull('realisasi_survey')
            ->whereNotNull('realisasi_dokumen_enjiniring')
            ->where('rab', '>', 0)
            ->whereNotNull('file_rab')
            ->where('file_rab', '!=', '')
            ->whereNotNull('file_tor')
            ->where('file_tor', '!=', '');
    }
}
