<?php

use Illuminate\Database\Seeder;

class IssuesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('issues')->insert([
            'common_report_id' => 1,
            'report_template_id' => 1,
            'status' => 'completed',
            'parameters' => '{"google_access_token":"ya29.GltZXXXXXXXXXXF4AoHKXrTr","ga_view_id":115358274,"target_y":"2017","target_m":"4","env":"local"}',
            'created_at' => '2017-05-23 12:00:00',
            'updated_at' => '2017-05-23 12:00:00',
        ]);
    }
}
