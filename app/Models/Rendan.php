<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Rendan extends Model
{
   use HasFactory;

   use HasUlids;

   protected $guarded = ['id', 'created_at', 'updated_at'];

   protected $appends = ['is_completed'];

   public function enjiniring(): BelongsTo
    {
        return $this->belongsTo(Enjiniring::class);
    }

    public function lakdan()
    {
        return $this->hasOne(Lakdan::class, 'rendan_id');
    }

    public function getIsCompletedAttribute()
    {
        return ($this->nilai_hpe > 0) &&
            !empty($this->dokumen_hpe) &&
            !empty($this->tanggal_rks) &&
            !empty($this->dokumen_rks);
    }

    public function scopeCompleted($query)
    {
        return $query->where('nilai_hpe', '>', 0)
            ->whereNotNull('dokumen_hpe')
            ->where('dokumen_hpe', '!=', '')
            ->whereNotNull('tanggal_rks')
            ->whereNotNull('dokumen_rks')
            ->where('dokumen_rks', '!=', '');
    }
}
