<?php

use Illuminate\Database\Seeder;

class ReportTemplatesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('report_templates')->insert([
            'title' => 'sns',
            'author' => 'ADDIX, Inc.',
            'description' => 'SNS REPORT',
            'created_at' => '2017-05-23 12:00:00',
            'updated_at' => '2017-05-23 12:00:00',
        ]);
    }
}
