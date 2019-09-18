<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Report extends Model
{
    public function issue()
    {
        return $this->belongsTo('App\Issue');
    }
}
