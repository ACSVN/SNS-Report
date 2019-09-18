<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateSocialAccountTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // Schema::create('social_account', function (Blueprint $table) {
        //     $table->increments('id');
        //     $table->string('user_name');
        //     $table->string('email');
        //     $table->string('access_token')->nullable();
        //     $table->string('social_id')->nullable();
        //     $table->integer('user_id')->unsigned();
        //     $table->foreign('user_id')
        //         ->references('id')->on('users');
        //     $table->string('types_of_social');
        //     $table->longtext('list_pages');
        //     $table->softDeletes();
        //     $table->timestamps();
        // });

        Schema::create('social_account', function (Blueprint $table) {
            $table->increments('id');
            $table->string('user_name');
            $table->string('email');
            $table->string('access_token')->nullable();
            $table->string('social_id')->nullable();
            $table->integer('user_id')->unsigned();
            $table->foreign('user_id')
                ->references('id')->on('users');
            $table->string('types_of_social');
            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('social_account');
    }
}
