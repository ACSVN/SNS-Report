@extends('dashboard')
@section('content')
<meta name="csrf-token" content="{{ csrf_token() }}">
<div style="text-align: center;">
    {!! Form::open(['url' => route('DownloadReport'), 'class' => 'form-download-report'] ) !!}
    	<p>Thank you for having used our services, Click below button to get your final report!</p>
      	<input type="hidden" id="excelFile" name="file_excel" value="{{Session::get('paramsFilePath')}}" /> </br>
        <!-- <button class="btn btn-success btn-download-report" type="submit"><i class="fa fa-cloud-download"><i/> Download Report</button> -->
        <div class="col-sm-offset-4 col-sm-4">
           <button class="btn btn-success"><i class="fa fa-cloud-download"> </i> Download Report</button>
        </div>
    {!! Form::close() !!}
</div>

@endsection
@push('scripts-footer')
<link rel="stylesheet" href="{{ asset('css/report-pages.css') }}">
@endpush
