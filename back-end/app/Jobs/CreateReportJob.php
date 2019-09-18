<?php
namespace App\Jobs;
use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use DB;
use App\Issue;
use Exception;
use Carbon\Carbon;

class CreateReportJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $issue;
    protected $report_id;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct(Issue $issue, $report_id)
    {
        $this->issue = $issue;
        $this->report_id = $report_id;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        // \Log::info($this->issue->id);

        try{
            $report_template_id = $this->issue->ReportTemplate->setID($this->issue->report_template_id);
            $report = $this->issue->ReportTemplate->generate($this->issue->parameters);
            // dd($report);
            $report->issue_id = $this->issue->id;
            $report->id = $this->report_id;

            DB::table('reports')
            ->where('id', $report->id)
            ->update([
                'issue_id' => $report->issue_id,
                'file_location'=>$report->file_location,
                'updated_at'=>Carbon::now()
            ]);

            // $report->update();

            $this->issue->status = 'completed';
            $this->issue->common_report_id = $report->id;
            $this->issue->save();
        }catch(Exception $e){
            $this->updateIssueStatusAsFailed();
            throw $e;
        }
    }

    protected function updateIssueStatusAsFailed() {
        $this->issue->status = 'failed';
        $this->issue->save();
    }
}
