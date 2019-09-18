<?php
namespace App\Http\Controllers;
use App\Issue;
use App\Jobs\CreateReportJob;
use Illuminate\Http\Request;
use DB;
use Carbon\Carbon;
use DateInterval;

class IssuesController extends Controller
{
    public function create(Request $request)
    {
        $report_id = DB::table('reports')->insertGetId([
            'file_location' => NULL,
            'issue_id' => NULL,
            'created_at' => Carbon::now(),
            'updated_at' => NULL
        ]);

        // $report_id = $request->input('report_id');
        $report_template_id = $request->input('report_template_id');
        $parameters = $request->input('parameters');

        // return $report_template_id;

        if (!($report_template_id && $parameters)) {
            abort(400, "Invalid parameter");
        }
        
        $issue = new Issue();
        $issue->common_report_id = $report_id;
        $issue->report_template_id = $report_template_id;
        $issue->parameters = json_encode($parameters);
        $issue->status = 'pending';
        $issue->save();

        $job = new CreateReportJob($issue,$report_id);
        dispatch($job);
        // dd($job);
        $responseData = DB::table('issues')
            ->join('reports', 'reports.id', '=', 'issues.common_report_id')
            ->select('issues.id','issues.common_report_id','issues.status','reports.file_location')
            ->where('issues.common_report_id',$report_id)
            ->get();
        $responseData = $responseData->toArray();

        while ($responseData[0]->status == 'pending') {
            sleep(5);
            $responseData = DB::table('issues')
                ->join('reports', 'reports.id', '=', 'issues.common_report_id')
                ->select('issues.id','issues.common_report_id','issues.status','reports.file_location')
                ->where('issues.common_report_id',$report_id)
                ->get();
            $responseData = $responseData->toArray();
        }
        
        return response()->json($responseData);
    }
}
