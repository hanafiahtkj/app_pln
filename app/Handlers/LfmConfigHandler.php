<?php

namespace App\Handlers;

class LfmConfigHandler extends \UniSharp\LaravelFilemanager\Handlers\ConfigHandler
{
    public function userField()
    {
        $user = auth()->user();

        if ($user && isset($user->unit_id)) {
            return $user->unit->kode;
        }

        return $user->id;
    }
}
