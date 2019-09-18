<?php
namespace App\Modules\Socialite;
use Laravel\Socialite\SocialiteManager;

use Session;

class SocialiteManagerCustom extends SocialiteManager
{
    /**
     * Create an instance of the specified driver.
     *
     * @return \Laravel\Socialite\Two\AbstractProvider
     */
    protected function createGoogleDriver()
    {
        $config = $this->app['config']['services.google'.Session::get('lang')];

        return $this->buildProvider(
            'Laravel\Socialite\Two\GoogleProvider', $config
        );
    }
}
?>
