<?php

namespace App\Http\Controllers;
use Request;
use App\Models\User;
use DB;
use Auth;
use Selector;
use Paging;
use Session;
use Facebook\Facebook;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        return view('modules.accounts.index');
    }

    public function social()
    {
        $user = Auth::user();

        $facebookAccounts = $user->facebookAccounts;
        // $twitterAccounts = $user->twitterAccounts;

        $facebookLoginUrl = $this->buildFacebookLoginUrl();
        // $twitterLoginUrl = $this->buildTwitterLoginUrl();

        /**
         * get admin role or not
         */
        $role_id = DB::table('users')->select('admin_flg')->where('id',Auth::id())->where('deleted_at',NULL)->get();
        $role_id = json_decode(json_encode($role_id), true);
        $role_id = $role_id[0]['admin_flg'];
        Session::put('role_id',$role_id);

        $data = compact('facebookLoginUrl');
        if ($facebookAccounts) {
            $data["facebook_accounts"] = $facebookAccounts->toArray();
        }
        return view('modules.accounts.link-socials', $data);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param \Illuminate\Http\Request $request
     *
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        User::create($request->all());

        return redirect()->action('UserController@index')->with('success', 'Create success');
    }

    /**
     * Display the specified resource.
     *
     * @param int $id
     *
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param int $id
     *
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request)
    {

    }


    /**
     * Remove the specified resource from storage.
     *
     * @param int $id
     *
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
    }



    public function editProfile()
    {
        return view('modules.accounts.edit', ['user' => User::findOrFail(Auth::user()->id), 'title' => 'Update profile'])->render();
    }

    public function updateProfile()
    {
        if (User::findOrFail(Auth::user()->id)->update(Request::all())) {
            if (!Request::ajax()) {
                return redirect('user');
            }
            return 1;
        }

    }

    protected function createFacebook()
    {
        return new Facebook([
            'app_id'=>getenv('FB_APP_ID'),
            'app_secret'=>getenv('FB_APP_SECRET'),
            'default_graph_version'=>getenv('GRAPH_VER'),
        ]);
    }

    public function selectSocialsAccount()
    {
        $selectedFacebookAccountEmail = Request::get('socialEmail');
        Session::put('socialEmail', $selectedFacebookAccountEmail);

        $user = Auth::user();
        $facebookAccount = $user->facebookAccounts()->where('email', $selectedFacebookAccountEmail)->first();
        $accessToken = $facebookAccount->access_token;

        $fb = $this->createFacebook();
        $img_user = $fb->get('me/picture', $accessToken);
        $img_user = $img_user->getHeaders();
        $img_user_path = $img_user['Location'];
        $imageData = base64_encode(file_get_contents($img_user_path));
        Session::put('imageData', $imageData);

        return redirect('user/pageList');
    }

    //Accounts function for Admin
    public function getListAccounts(){
        if (Request::ajax()) {
            $list_accounts = DB::table('users')->join('group_users', 'users.group_id', '=', 'group_users.id')
            ->select('users.*', 'group_users.group_name')
            ->get();
            
            $list_accounts['data'] = json_decode(json_encode($list_accounts), true);
            return response()->json($list_accounts);  
        }
        return view('modules.accounts.list-accounts');
    }

    public function editAccount($userId){
        $detail_account = DB::table('users')
        ->where('users.id',$userId)->get()->first();
        $detail_account = json_decode(json_encode($detail_account), true);
        //get list group
        $list_group = DB::table('group_users')->select('id','group_name')
        ->whereNull('group_users.deleted_at')->get();
        $list_group = json_decode(json_encode($list_group), true);

        return view('modules.accounts.edit-account',compact('detail_account','list_group'));
    }

    public function removeAccount(){
        $count_admin = $this->countAdminRole();
        $check_admin = $this->checkAdminRole($_POST['user_id']);

        if($count_admin == 1 && $check_admin['admin_flg'] == 1){
          return 404;  
        }else{
          return DB::table('users')
          ->where('id', $_POST['user_id'])
          ->update(['deleted_flg'=>1,'deleted_at'=>DB::raw('NOW()')]);
        }
    }

    public function saveAccount(Request $request){
      if($_POST['deleted_flg'] != 1){
        $deleted_at = null;
      }else{
        $deleted_at = DB::raw('NOW()');
      }
      Session::forget('outFile');
      Session::forget('pptxFile');
      Session::forget('excelFile');

      DB::table('users')
            ->where('id', $_POST['userID'])
            ->update(['name' => $_POST['userName'],
                      'email'=> $_POST['email'],
                      'password' => bcrypt($_POST['password']),
                      'status'=>0,
                      'admin_flg'=>$_POST['admin_flg'],
                      'group_id'=>$_POST['group_id'],
                      'deleted_flg'=>$_POST['deleted_flg'],
                      'deleted_at'=>$deleted_at
                      ]);
      return redirect('/user/manageListAccounts');
    }

    public function addAccount(){
        //get list group
        $list_group = DB::table('group_users')->select('id','group_name')
        ->whereNull('group_users.deleted_at')->get();
        $list_group = json_decode(json_encode($list_group), true);

        return view('modules.accounts.add-account',compact('list_group'));
    }

    public function addNewAccount(){
      if($_POST['deleted_flg'] != 1){
        $deleted_at = null;
      }else{
        $deleted_at = DB::raw('NOW()');
      }
      DB::table('users')
            ->insert(['name' => $_POST['userName'],
                      'email'=> $_POST['email'],
                      'password' => bcrypt($_POST['password']),
                      'status'=>0,
                      'admin_flg'=>$_POST['admin_flg'],
                      'group_id'=>$_POST['group_id'],
                      'deleted_flg'=>$_POST['deleted_flg'],
                      'deleted_at'=>$deleted_at
                      ]);
      return redirect('/user/manageListAccounts');
    }

    public function countAdminRole(){
      return DB::table('users')->where('admin_flg',1)->whereNull('deleted_at')->count();
    }

    public function checkAdminRole($user_id){
      $admin_flg = DB::table('users')->select('admin_flg')->where('id',$user_id)->first();
      $admin_flg = json_decode(json_encode($admin_flg), true);
      return $admin_flg;
    }

    //Group function for Admin
    public function getGroup(){
        if (Request::ajax()) {
            $list_groups = DB::table('group_users')->get();
            $list_groups['data'] = json_decode(json_encode($list_groups), true);
            return response()->json($list_groups);  
        }
        return view('modules.groups.list-groups');
    }

    public function editGroup($groupId){
        //get list group
        $detail_group = DB::table('group_users')->where('id',$groupId)->get()->first();
        $detail_group = json_decode(json_encode($detail_group), true);

        return view('modules.groups.edit-group',compact('detail_group'));
    }

    // public function removeGroup(){
    //   DB::table('group_users')
    //     ->where('id', $_POST['groupId'])
    //     ->update(['deleted_at'=>DB::raw('NOW()')]);

    //   DB::table('users')
    //       ->where('group_id', $_POST['groupId'])
    //       ->update(['deleted_flg' => $_POST['deleted_flg'],
    //                 'deleted_at'=>$deleted_at
    //                 ]);
    // }

    public function saveGroup(){

      if($_POST['deleted_flg'] != 1){
        $deleted_at = null;
      }else{
        $deleted_at = DB::raw('NOW()');
      }

      DB::table('group_users')
            ->where('id', $_POST['groupID'])
            ->update(['group_name' => $_POST['groupName'],
                      'deleted_at'=>$deleted_at
                      ]);

      DB::table('users')
            ->where('group_id', $_POST['groupID'])
            ->update(['deleted_flg' => $_POST['deleted_flg'],
                      'deleted_at'=>$deleted_at
                      ]);

      return redirect('/user/manageListGroup');
    }

    public function addGroup(){
        return view('modules.groups.add-group');
    }

    public function addNewGroup(){
      if($_POST['deleted_flg'] != 1){
        $deleted_at = null;
      }else{
        $deleted_at = DB::raw('NOW()');
      }
      $gr_nm_exist = DB::table('group_users')
      ->where('group_name', $_POST['groupName'])->get()->count();

      if($gr_nm_exist>0){
        return view('modules.groups.add-group')->with('msg_err','Group name existed, please create another Group/Team');
      }else{
        DB::table('group_users')
              ->insert(['group_name' => $_POST['groupName'],
                        'deleted_at'=>$deleted_at
                        ]);
        return redirect('/user/manageListGroup');
      }
    }

    /**
     * @return string
     */
    protected function buildFacebookLoginUrl()
    {
        $fb = $this->createFacebook();
        $helper = $fb->getRedirectLoginHelper();
        $permissions = ['email', 'pages_show_list', 'manage_pages', 'read_audience_network_insights', 'read_custom_friendlists', 'read_insights'];
        $facebookLoginUrl = $helper->getLoginUrl(action('FacebookController@callback'), $permissions);
        return $facebookLoginUrl;
    }
}
