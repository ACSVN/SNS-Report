<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| This file is where you may define all of the routes that are handled
| by your application. Just tell Laravel the URIs it should respond
| to using a Closure or controller method. Build something great!
|
*/

Route::get('/',   ['uses' => 'Auth\LoginController@showLoginForm']);

Route::get('/user/logout', function() {
    Auth::logout();
    Session::flush();
    return redirect('/');
})->name('user_logout');
//Route::get('/test',['uses'=>'ReportController@report']);
Route::group(['middleware' => 'auth'], function () {

    Route::get('/user/accounts', 'UserController@social')->middleware('check.terms');
    
    //route for account 
    Route::get('/user/manageListAccounts', 'UserController@getListAccounts');
    Route::get('/user/editUser/{userID}', 'UserController@editAccount');
    Route::post('/user/editUser', 'UserController@saveAccount')->name('saveAccount');
    Route::post('/user/deleteAccount', 'UserController@removeAccount');
    Route::get('/user/addUser', 'UserController@addAccount');
    Route::post('/user/addUser', 'UserController@addNewAccount')->name('addNewAccount');

    //route for group/team
    Route::get('/user/manageListGroup', 'UserController@getGroup');
    Route::get('/user/editGroup/{groupID}', 'UserController@editGroup');
    Route::post('/user/editGroup', 'UserController@saveGroup')->name('saveGroup');
    Route::get('/user/addGroup', 'UserController@addGroup');
    Route::post('/user/addGroup', 'UserController@addNewGroup')->name('addNewGroup');

    Route::post('/user/selectSocialsAccount', 'UserController@selectSocialsAccount')->name('selectedAccount');
    Route::get('/user/unlinkSocial/{email}', 'UserController@unlinkSocials');

    Route::post('/terms/accept', 'Auth\RegisterController@readTerms')->name('accept.terms');
    Route::get('/terms/accept', 'Auth\RegisterController@readTerms');

    Route::get('/user/update-profile', 'UserController@editProfile');
    Route::post('/user/update-profile', 'UserController@updateProfile');
    Route::post('/report/create', 'ReportController@index');
    
    //----- Check login Facebook account -----
    Route::get('/user/pageList', 'UserController@index');
    Route::get('/report/input', 'ReportController@editPPT');
    Route::post('/report/success', 'ReportController@report')->name('DrawReportClient');
    Route::post('/report/download', 'ReportController@downloadReport')->name('DownloadReport');
    // });

    Route::get('/facebook/pages', 'FacebookController@pages');
    Route::get('/facebook/callback', 'FacebookController@callback');
    Route::get('/facebook/unlink/{email}', 'FacebookController@unlink');

    Route::get('/', function() {
        return redirect('/user/accounts');
    });
});

Auth::routes();

Route::any('{catchall}', function($page) {
    return redirect('/user/accounts');
})->where('catchall', '(.*)');

Auth::routes();
