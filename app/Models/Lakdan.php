<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Lakdan extends Model
{
   use HasFactory;

   use HasUlids;

   protected $guarded = ['id', 'created_at', 'updated_at'];

   protected $appends = ['is_completed'];

   public function rendan(): BelongsTo
   {
        return $this->belongsTo(Rendan::class);
   }

    public function kontrak()
    {
        return $this->hasOne(Kontrak::class, 'lakdan_id');
    }

    public function getIsCompletedAttribute()
    {
        return !empty($this->realisasi_tanggal_hps) &&
            ($this->nilai_hps > 0) &&
            !empty($this->dokumen_hps) &&
            !empty($this->realisasi_persiapan_pengadaan) &&
            !empty($this->realisasi_pengumuman_pengadaan) &&
            !empty($this->realisasi_pendaftaran_ambil_dokumen) &&
            !empty($this->realisasi_pemasukan_penawaran) &&
            !empty($this->realisasi_pembukaan_evaluasi) &&
            !empty($this->realisasi_klarifikasi_negosiasi);
    }

    public function scopeCompleted(Builder $query): Builder
    {
        return $query->whereNotNull('realisasi_tanggal_hps')
            ->where('nilai_hps', '>', 0)
            ->whereNotNull('dokumen_hps')
            ->where('dokumen_hps', '!=', '')
            ->whereNotNull('realisasi_persiapan_pengadaan')
            ->whereNotNull('realisasi_pengumuman_pengadaan')
            ->whereNotNull('realisasi_pendaftaran_ambil_dokumen')
            ->whereNotNull('realisasi_pemasukan_penawaran')
            ->whereNotNull('realisasi_pembukaan_evaluasi')
            ->whereNotNull('realisasi_klarifikasi_negosiasi');
    }
}
