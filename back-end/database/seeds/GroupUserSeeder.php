<?php

use Illuminate\Database\Seeder;

class GroupUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('group_user')->insert([
            [
                'group_name' => 'SNS Team'
            ],
            [
                'group_name' => 'Advertising agency'
            ]
        ]);
    }
}
