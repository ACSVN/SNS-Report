<?php
namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Session;
session_start();
class UsersController extends Controller
{
	public function getUserInfor($id)
    {
        $command = sprintf(
            // 'cd %s; Rscript index.R %s %s %s', /*for ubuntu*/ 
            'E:/R/R-3.4.0/bin/x64/Rscript.exe C:/xampp/htdocs/report-sns-generator/report_templates/shared/fbr_auth.R %s 2>&1', 
            $id
             /*for windows*/ 
        );

        exec($command, $result);
        // echo '<pre>'; print_r($result); exit;

        //redirect to main system
        if($result[count($result)-1] == "Execution halted"){
            return $result = ['result'=>false];
        }else{
            return $result = ['result'=>true];
        }
    }
}