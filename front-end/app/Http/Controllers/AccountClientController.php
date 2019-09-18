<?php

namespace App\Http\Controllers;
use Datatables;
use Illuminate\Http\Request;

class AccountClientController extends Controller
{
    public function index(){
      return view('dashboard.blade');
    }
}
