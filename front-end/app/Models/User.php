<?php

namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Database\Eloquent\SoftDeletes;

class User extends Authenticatable
{
    use Notifiable;
    use SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $table = 'users';
    protected $fillable = [
        'name', 'email', 'phone', 'password'
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $dates = ['deleted_at'];

    public function reports()
    {
        return $this->hasMany('App\Models\Report', 'user_id', 'id');
    }

    public function social()
    {
        return $this->hasMany('App\Models\Social');
    }

    public function facebookAccounts()
    {
        return $this->hasMany('App\FacebookAccount');
    }

    public function twitterAccounts()
    {
        return $this->hasMany('App\FacebookAccount');
    }
}
