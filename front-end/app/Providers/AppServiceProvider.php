<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        // make https URL when this app is deployed behind a load balancer w/ SSL termination
        if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && mb_strtolower($_SERVER['HTTP_X_FORWARDED_PROTO']) == 'https') {
            \URL::forceSchema('https');
        }
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
