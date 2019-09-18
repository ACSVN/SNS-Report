<?php
namespace App\Http\Controllers;

use Request;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use DB;
use Auth;
use Selector;
use Paging;
use Session;
use Facebook\Facebook;

class FacebookController extends Controller
{
    /**
     * @var Facebook
     */
    protected $facebook;

    public function pages()
    {
        if (!Request::ajax()) {
            throw new BadRequestHttpException();
        }

        $user = Auth::user();

        $facebook = $this->createFacebook();

        $selectedFacebookAccountEmail = Session::get('socialEmail');

        $selectedFacebookAccount = $user->facebookAccounts()->where('email', $selectedFacebookAccountEmail)->first();
        $accessToken = $selectedFacebookAccount->access_token;

        $facebookAccounts = $facebook->get('me/accounts?limit=2000', $accessToken);
        $facebookAccountsData = $facebookAccounts->getDecodedBody();

        $x = (array)$facebookAccountsData['data'];
        if (empty($x)) {
            $facebookAccountsData = array('data' => '');
        }
        return response()->json($facebookAccountsData);
    }

    public function callback()
    {
        $user = Auth::user();

        $facebook = $this->createFacebook();

        // get access token
        $helper = $facebook->getRedirectLoginHelper();
        if (isset($_GET['state'])) {
            $helper->getPersistentDataHandler()->set('state', $_GET['state']);
        }
        $accessToken = $helper->getAccessToken();
        $accessTokenValue = $accessToken->getValue();

        // get id, name, email account which link to sns system
        $facebookUser = $facebook->get('me?fields=id,name,email', $accessToken)->getDecodedBody();

        // find existing facebook account including unlinked ones
        $facebookAccount = $user->facebookAccounts()
            ->withTrashed()
            ->where('email', $facebookUser['email'])
            ->first();

        if ($facebookAccount) {
            $facebookAccount->update(['access_token' => $accessTokenValue]);
            $facebookAccount->restore();
        } else {
            $user->facebookAccounts()->create([
                'access_token' => $accessTokenValue,
                'facebook_user_id' => $facebookUser['id'],
                'name' => $facebookUser['name'],
                'email' => $facebookUser['email']
            ]);
        }

        return redirect('user/accounts');
    }

    public function unlink($email)
    {
        $user = Auth::user();
        $user->facebookAccounts()->where('email', $email)->delete();

        return redirect('user/accounts');
    }

    protected function createFacebook()
    {
        return new Facebook([
            'app_id' => getenv('FB_APP_ID'),
            'app_secret' => getenv('FB_APP_SECRET'),
            'default_graph_version' => getenv('GRAPH_VER'),
        ]);
    }
}
