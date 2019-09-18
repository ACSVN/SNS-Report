<?php

namespace App\Http\Controllers\Auth;
use Crypt;
// use App\User;
use Validator;
use App\Http\Controllers\Controller;
use Illuminate\Contracts\Auth\Guard;
use Illuminate\Foundation\Auth\RegistersUsers;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Http\Request;
use App\Models\Social;
use App\Models\User;
use DB, Input, Auth, Session;

class RegisterController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Register Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users as well as their
    | validation and creation. By default this controller uses a trait to
    | provide this functionality without requiring any additional code.
    |
    */

    use RegistersUsers;

    /**
     * Where to redirect users after login / registration.
     *
     * @var string
     */
    protected $auth;
    // protected $redirectTo = '/home';
    
    // protected $ENCRYPTION_KEY = 'addx.vietname.!@#$%^&*-2015';

    /**
     * Create a new controller instance.
     */
    public function __construct(Guard $auth)
    {
        $this->auth = $auth;
        // $this->middleware('guest');
    }

    /**
     * Get a validator for an incoming registration request.
     *
     * @param array $data
     *
     * @return \Illuminate\Contracts\Validation\Validator
     */
    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => 'required|max:255',
            'email' => 'required|email|max:255|unique:users',
            'password' => 'required|min:6|confirmed',
        ]);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param array $data
     *
     * @return User
     */
    protected function register(Request $request)
    {
        $check_email = DB::table('users')->select('email')->where('email',$request->input('email'))->where('deleted_at',NULL)->get();
        $check_email = json_decode(json_encode($check_email), true);
        
        if(empty($check_email)){
            // $encrypted_pass = $this->encrypt($request->input('password'));
            User::create([
                'name' => $request->input('name'),
                'email' => $request->input('email'),
                'password' => bcrypt($request->input('password')),
                // 'password' => $encrypted_pass,
            ]);
            return redirect('login');
        }else{
            return redirect('register')->withErrors(['Your email registerd before. Please use another email. Thank you']);
        }
    }


    public function readTerms(Request $request)
    {
        if (Auth::check()) {
            // Accepted
            if (Auth::user()->status == 1) {
                return redirect('user/accounts');
            } else {
                if ($request->input('accept')) {
                    User::where('id', '=', Auth::id())->update(['status' => 1]);

                    return redirect('user/accounts');
                } elseif ($request->input('decline')) {
                    Auth::logout();

                    return redirect('/');
                } else {
                    return view('termspage');
                }
            }
        }
    }

     /**
     * Returns an encrypted & utf8-encoded
     */
    // function encrypt($pass_string) {
    //     $encrypted = Crypt::encrypt($pass_string);
    //     return $encrypted;
    // }

    /**
     * Returns decrypted original string
     */
    // function decrypt($encrypted_string) {
    //     $decrypted = Crypt::decrypt($encrypted_string);

    //     return $decrypted;
    // }
}
