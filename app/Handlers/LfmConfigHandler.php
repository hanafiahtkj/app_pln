<?php

namespace App\Handlers;

class LfmConfigHandler extends \UniSharp\LaravelFilemanager\Handlers\ConfigHandler
{
    public function userField()
    {
        $user = auth()->user();

        if ($user->hasRole('superuser')) {
            return '';
        }

        if ($user && isset($user->unit_id)) {
            return $user->unit->name;
        }

        return $user->id;
    }
}
