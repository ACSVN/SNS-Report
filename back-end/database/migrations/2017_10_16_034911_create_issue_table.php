<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateIssueTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::dropIfExists('issues');
        Schema::create('issues', function (Blueprint $table) {
            $table->increments('id');
            $table->integer('common_report_id');
            $table->integer('report_template_id')->unsigned()->nullable();
            $table->foreign('report_template_id')->references('id')->on('report_templates');
            $table->longText('parameters');
            $table->enum('status', ['pending', 'completed', 'failed']);
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
        Schema::dropIfExists('issues');
    }
}
