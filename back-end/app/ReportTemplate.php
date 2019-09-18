<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Symfony\Component\CssSelector\Exception\InternalErrorException;

class ReportTemplate extends Model
{
    protected $id;

    public function setID($id)
    {
        $this->id = $id;
        $this->title = 'sns';
    }

    public function generate($parameters){
    	$report = new Report();
        $report_param = json_decode($parameters,true);
        $report_nm = $report_param['report_name'];

        // input parameter and output file path.
        $workingDir = $this->getDirectory();
        $paramsFilePath = tempnam(storage_path("app/tmp"), "p_");
        // $outputFileName = uniqid() . ".pptx";
        $outputFileName = $this->getOutputFileName($workingDir,$report_nm);
        $outputFilePath = storage_path("app/tmp/".$outputFileName);
        file_put_contents($paramsFilePath, $parameters);

        // execute ReportTemplate program
        $this->callRscript($workingDir, $paramsFilePath, $outputFilePath);

        // upload to S3 bucket
        $report->file_location = $this->uploadToS3Bucket($outputFileName, $outputFilePath);

        // clean up temp files
        unlink($paramsFilePath);
        unlink($outputFilePath);
        
        // echo $report->file_location; exit;
        // $report->file_location = $outputFilePath;
        
        return $report;
    }


    /**
     * @param string $objectKey
     * @param string $filePath
     * @return string JSON string of `file_location` format
     */
    protected function uploadToS3Bucket($objectKey, $filePath)
    {
        $s3 = \App::make('aws')->createClient('s3');
        $s3->putObject(array(
            'Bucket' => env('AWS_S3_BUCKET'),
            'Key' => $objectKey,
            'SourceFile' => $filePath,
        ));

        return json_encode([
            "type" => "s3",
            "bucket" => env('AWS_S3_BUCKET'),
            "object_key" => $objectKey
        ]);
    }

    protected function getDirectory()
    {   
        if (!$this->id) {
            throw new \Exception('No ReportTemplate ID is provided');
        }
        return base_path('report_templates/' . $this->title);
    }

    /**
     * @param string $workingDir
     * @param string $paramsFilePath
     * @param string $outputFilePath
     * @throws InternalErrorException
     */
    protected function callRscript($workingDir, $paramsFilePath, $outputFilePath)
    {
        //param for windows
        // $workingDir = str_replace('\'', '/', $workingDir);
        // $paramsFilePath = str_replace('\'', '/', $paramsFilePath);
        // $outputFilePath = str_replace('\'', '/', $outputFilePath);
        //end param for windows

        // $command = sprintf(
        //     'Rscript index.R %s %s %s',
        //     // 'E:/R/R-3.4.0/bin/x64/Rscript.exe C:/xampp/htdocs/report-sns-generator/report_templates/sns/index.R %s %s %s 2>&1',
        //     escapeshellarg($paramsFilePath),
        //     escapeshellarg($outputFilePath),
        //     escapeshellarg(storage_path('logs/R-error.log'))
        // );


        $command = sprintf(
            'cd %s; Rscript index.R %s %s %s 2>&1',
            escapeshellarg($workingDir),
            escapeshellarg($paramsFilePath),
            escapeshellarg($outputFilePath),
            escapeshellarg(storage_path('logs/R-error.log'))
        );
        exec($command, $output);
        // echo '<pre>'; print_r($output); exit;
    }

    protected function getOutputFileName($workingDir,$report_nm){
        if($this->id == 1){
            $outputFileName = $report_nm . '_'. uniqid() . ".xlsx";
            $copy_template = sprintf(
                "cp %s %s 2>&1",
                escapeshellarg($workingDir.'/template.xlsx'),
                escapeshellarg(storage_path("app/tmp/$outputFileName"))
            );
            exec($copy_template,$res);          
            return $outputFileName;
        }else{
            return uniqid() . ".pptx";
        }
    }
    
}
