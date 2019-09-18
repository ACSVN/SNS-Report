<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use DB, Auth, Response, Session, Input;
use App\Http\Controllers\UserController;
use Illuminate\Database\Eloquent\Model;
use App\Http\Controllers\IssueController;
use DateTime,DateTimeZone,DatePeriod,DateInterval;
use Carbon\Carbon;
use ZipArchive;
use GuzzleHttp\Client;
use GuzzleCache;
use LRedis;
class ReportController extends Controller
{
    public $arrResult = Array();
    public $arrResultExcel = Array();
    public $snsExcel = Array();
    public $arr_data_by_metric = Array();

    // public $baseUrl = "http://report-sns-generator.com.addix.tokyo";
    public $apiVersion = "api";

    public function index(Request $request){
        if($request->isMethod('post')) {
            Session::put('pageName',$request->pageName);
            Session::put('pageID',$request->pageID);
            Session::put('fanPageCreation',$request->fanPageCreation);
            return response()->json(array(
                'pageName'=>Session::get('pageName'),
                'pageID'=>Session::get('pageID'),
                'fanPageCreation'=>Session::get('fanPageCreation')));
        }
    }

    protected function getAccessToken(){
        $pageID = Session::get('pageID');
        $pageName = Session::get('pageName');
        $fanPageCreation = Session::get('fanPageCreation');

        $user = Auth::user();
        $facebookAccount = $user->facebookAccounts()->where('email', Session::get('socialEmail'))->first();
        $accessToken = $facebookAccount->access_token;

        //get fan page creation
        $fanPageCreation = date('Y/m/d',strtotime($fanPageCreation));        

        $vars = [
            "pageID" => $pageID,
            "fanPageCreation" => $fanPageCreation,
            "accessToken" => $accessToken,
        ];

        Session()->put('sess_var', $vars);

        return array('pageName'=>$pageName,'pageID'=>$pageID,'fanPageCreation'=>$fanPageCreation,'accessToken'=>$accessToken);
    }

    public function editPPT(){
        $data = $this->getAccessToken();
        $pageID = $data['pageID'];
        $pageName = $data['pageName'];
        $fanPageCreation = $data['fanPageCreation'];
        $userID = Auth::id();

        if(Session::get('msg_err')){
            $msg_err = Session::get('msg_err');
        }

        return view('modules.report.index', compact('pageName','pageID','msg_err','fanPageCreation', 'userID'));
    }

    public function report(Request $request){
        Session::put('paramsFilePath','');
        Session::put('msg_err','');
        $pageID = Session::get('sess_var.pageID');
        $accessToken = Session::get('sess_var.accessToken');

        $input = Input::all();
        $stDate = new DateTime($input['start_date']);
        $stDate->modify('-15 hours');
        $stDate = $stDate->format("Y-m-d"); 

        $endDate = new DateTime($input['end_date']);
        $endDate->modify('-15 hours');
        $endDate = $endDate->format("Y-m-d"); 

        if(date('Y-m-d',strtotime($stDate)) < $input['start_date']){
            $since = date('Y-m',strtotime($input['start_date']));
            $since_fdate = date('Y-m-d',strtotime($input['start_date']));
        }else{
            $since = date('Y-m',strtotime($stDate));
            $since_fdate = date('Y-m-d',strtotime($stDate));
        }

        if(date('Y-m-d',strtotime($endDate)) < $input['end_date']){
            $until = date('Y-m',strtotime($input['end_date']));
            $until_fdate = date('Y-m-d',strtotime($input['end_date']));
        }else{
            $until = date('Y-m',strtotime($endDate));
            $until_fdate = date('Y-m-d',strtotime($endDate));
        }

        $report_name = $input['report_name'];

        $report_template_id = 1;

        $parameters = [
            'pageID' => $pageID,
            'accessToken' => $accessToken,
            'since_fdate' => $since_fdate,
            'until_fdate' => $until_fdate,
            'report_name' => $report_name
        ];

        $result = $this->requestAPI(
            'GET',
            '/issues/create',
            compact('report_template_id', 'parameters')
        );
        // return $result;
        $result = json_decode($result,true);

        if($result[0]['status'] == 'completed'){
            $this->sns_report($result[0]);
        }
    }

    public function downloadReport(){
        $paramsFilePath = Session::get('paramsFilePath');
        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="'.basename($paramsFilePath).'"');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Content-Length: ' . filesize($paramsFilePath));
        readfile($paramsFilePath);
        exit;
    }

    private function requestAPI($method, $path, $data = array(), $options = array()) {
        // init curl handler
        $ch = curl_init();
        // build URL
        $url = env('API_URL'). "/" . $this->apiVersion . $path;
        if (preg_match('/post/i', $method)) {
            $options[CURLOPT_POST] = true;
            $options[CURLOPT_POSTFIELDS] = $data;
        } else {
            $parsed = parse_url($url);
            if (isset($parsed["query"])) {
                parse_str($parsed["query"], $arr);
                $data = array_merge($arr, $data);
            }
            $parsed["query"] = http_build_query($data);
            $url = $parsed["scheme"] . "://" . $parsed["host"] . $parsed["path"] . "?" . $parsed["query"];
            
        }
        $options[CURLOPT_URL] = $url;
        // BASIC Auth
        $options[CURLOPT_HTTPAUTH] = CURLAUTH_BASIC;
        // $options[CURLOPT_USERPWD] = $this->basicAuthUsername . ":" . $this->basicAuthPassword;
        // other options
        $options[CURLOPT_RETURNTRANSFER] = true;
        $options[CURLOPT_FOLLOWLOCATION] = true;
        $options[CURLOPT_MAXREDIRS]      = 10;
        // set curl options
        curl_setopt_array($ch, $options);
        $result = curl_exec($ch);
        // dd($result);
        return $result;
    }

    /**
     * show url download link into s3 aws to client
     */
    public function sns_report($data)
    {
        $file_location = json_decode($data['file_location']);
        $file_location->bucket;
        $file_location->object_key;

        $s3 = \App::make('aws')->createClient('s3');

        $workingDir = storage_path('app/public/test.xlsx');
        $paramsFilePath = storage_path('app/public/'.$file_location->object_key);
        
        #for windows
        // $workingDir = str_replace('/', '\\', storage_path('app/public/test.xlsx'));
        // $paramsFilePath = str_replace('/', '\\', storage_path('app/public/'.$file_location->object_key));

        $file_sample = sprintf(
            "cp %s %s 2>&1", # for ubuntu
            // "copy %s %s 2>&1", # for windows
            escapeshellarg($workingDir),
            escapeshellarg(storage_path("app/tmp/".$file_location->object_key)) #for ubuntu
            // escapeshellarg($paramsFilePath)
        );
        // echo $file_sample; exit;
        exec($file_sample,$res);

        $result = $s3->getObject(array(
            'Bucket' => $file_location->bucket,
            'Key'    => $file_location->object_key,
            'SaveAs' => $paramsFilePath
        ));
        Session::put('paramsFilePath',$paramsFilePath);
        echo view('modules.report.downloadPPT')->render();
    }
}