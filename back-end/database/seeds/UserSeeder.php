<?php

use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        DB::table('users')->insert([
            [
                'name' => 'Admin',
                'email' => 'manager@addix.vn',
                'password' => Hash::make('123'),
                'status' => 1,
                'remember_token' => null,
                'admin_flg' => 1,
                'group_id' => 1,
                'deleted_flg' => 0,
                'deleted_at' => null,
                'created_at' => null,
                'updated_at' => null
            ]
        ]);
    }
}
