<?php

// app/Models/Holiday.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Prk extends Model
{
    use HasFactory;

    use HasUlids;

    protected $guarded = ['id', 'created_at', 'updated_at'];

    public function pakets(): HasMany
    {
        return $this->hasMany(Paket::class, 'prk_id');
    }

    public function paketEnjinirings(): HasMany
    {
        return $this->hasMany(PaketEnjiniring::class, 'prk_id');
    }

    public function bidang(): BelongsTo
    {
        return $this->belongsTo(Bidang::class);
    }

    public function unit(): BelongsTo
    {
        return $this->belongsTo(Unit::class);
    }
}
