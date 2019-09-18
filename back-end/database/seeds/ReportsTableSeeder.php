<?php

use Illuminate\Database\Seeder;

class ReportsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('reports')->insert([
            'issue_id' => 1,
            'file_location' => '{"type":"s3","bucket":"faro-report-file-server","object_key":"59250f5a26dcb.pptx"}',
            'created_at' => '2017-05-23 12:00:00',
            'updated_at' => '2017-05-23 12:00:00',
        ]);
    }
}
