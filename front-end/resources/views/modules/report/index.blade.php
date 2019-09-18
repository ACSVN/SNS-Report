@extends('dashboard')
@section('content')
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <div class="box-body">
        {!! Form::open(['url' => route('DrawReportClient'), 'class' => 'form-horizontal form-make-report', 'id' => 'form-make-report'] ) !!}
        <h2 class="form-create-user-heading">Choose period and report name</h2>
        <p id="alert_msg">{{ isset($msg_err) ? $msg_err : '' }}</p>
        <hr noshade>
        <div class="form-group">
          <label class="control-label col-sm-4">Page Name:</label>
          <div class="col-sm-4">
            <input class="form-control"
                   id="inputPageName"
                   name="page_name" value="{{$pageName}}"
                   type="text">
            <input class="form-control"
                   required="required"
                   id="inputPageID"
                   name="page_id" value="{{$pageID}}"
                   type="hidden">
          </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-4">Start Date:</label>
            <div class="col-sm-4">
              <input required type="text" placeholder="Start Date" class="form-control form-control-1"
                     id="startDt"
                     name="start_date"
                   data-provide="datepicker" data-date-end-date="0d">
            </div>
        </div>

        <div class="form-group">
            <label class="control-label col-sm-4">End Date:</label>
            <div class="col-sm-4">
              <input required type="text" placeholder="End Date" class="form-control form-control-2"
                     id="endDt"
                     name="end_date"
                     data-provide="datepicker" data-date-end-date="0d">
            </div>
        </div>

        <div class="form-group">
            <label for="inputReportName" class="control-label col-sm-4">Report Name:</label>
            <div class="col-sm-4">
              <input required type="text" placeholder="Report Name" class="form-control" id="inputReportName"
                     name="report_name">
              <input type="hidden" id="date" name="current_date">
              <input type="hidden" id="userID" name="userID" value="{{$userID}}">
            </div>
        </div>
       
        <div class="col-sm-offset-4 col-sm-10">
           <button class="btn btn-info" formnovalidate value=""><i class="fa fa-tasks"> </i> Create Report</button>
        </div>

        <div class="col-sm-offset-2 col-sm-10">
          <div class="alert alert-warning alert-dismissible fade in" style="display: none;">
            Please fill out these input!
          </div>
          <div class="alert alert-danger alert-dismissible fade in" style="display: none;">
            End date must larger than start date!
          </div>
        </div>
        
        {!! Form::close() !!}
    </div>
@endsection
@push('scripts-footer')
@include('partials/script')
@include('partials/css')
<style type="text/css">
.progress-bar-bg {
    height: 20px;
    width: 400px;
    border-radius: 4px;
    background-color: #FFFFFF;
    display: inline-block;
    margin: 20px 0;
    left: 58% !important;
    top: 65% !important;
    overflow: visible !important;
    clip: auto !important;
    font-size: 30px;
    position: absolute;
}

.progress-bar-inner {
    background-color: red;
    border-radius: 4px;
    height: 100%;
    width: 0%;
}
</style>
<!-- <link rel="stylesheet" href="{{ asset('css/bootstrap-datepicker3.css') }}">
<link rel="text/javascript" href="{{ asset('js/bootstrap-datepicker.min.js') }}"> -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css"/>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/js/bootstrap-datepicker.min.js"></script>
<script type="text/javascript">
    Date.prototype.SubtractMonth = function(numberOfMonths) {
      var d = this;
      d.setMonth(d.getMonth() - numberOfMonths);
      return d;
    }

    $(document).ready(function () {
        jQuery(function() {
          var startDt = $('input#startDt');
          var endDt = $('input#endDt');
          if (startDt.length > 0) {
            startDt.datepicker({
              format: "yyyy/mm/dd",
              startDate: new Date('<?= $fanPageCreation ?>'),
              autoclose: true
            });
            endDt.datepicker({
              format: "yyyy/mm/dd",
              autoclose: true
            });
          }
        });


        document.getElementById("form-make-report").onsubmit = function () {
            if (!document.getElementById("inputReportName").value || !document.getElementById("startDt").value || !document.getElementById("endDt").value || !document.getElementById("inputPageName").value) {
                $("p#errInput").remove();
                $(".alert-warning").show('medium');
                $(".alert-danger").hide();
                return false;
            }else if(document.getElementById("endDt").value < document.getElementById("startDt").value){
                if($("p#errInput").length==0){
                  $(".alert-danger").show('medium');
                  $(".alert-warning").hide();
                }
                return false;
            }else{
                $('.progress-bar-bg').show();
                $("p#errInput").remove();
                $(".alert").hide();
                $('#box-lock-report').removeClass('hidden');
            }
        }

        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();
        if(dd<10){
            dd='0'+dd;
        } 
        if(mm<10){
            mm='0'+mm;
        } 
   
        var today = yyyy+'/'+mm+'/'+dd;


        //get previous month follow by today params
        var d = new Date(today);
        var pre_today = d.SubtractMonth(1);
        var pre_dd = pre_today.getDate();
        var pre_mm = pre_today.getMonth()+1; //January is 0!
        var pre_yyyy = pre_today.getFullYear();
        if(pre_dd<10){
            pre_dd='0'+pre_dd;
        } 
        if(pre_mm<10){
            pre_mm='0'+pre_mm;
        } 
        var pre_month = pre_yyyy + "/" + pre_mm + "/" + pre_dd;

        document.getElementById("endDt").value = today;
        document.getElementById("startDt").value = pre_month;
    });

   

    var date_picker2 = function () {
        $(".line").each(function (index, element) {
            var startDate = new Date();
            var date = new Date();
            var FromEndDate = new Date();

            /* Find 'From' */
            $(this).find(".form-control-1").addClass("from" + index);

            /* Find 'To' */
            $(this).find(".form-control-2").addClass("to" + index);

            $(".from" + index).datepicker({
                autoclose: true,
                minDate: 0,
                format: 'yyyy/mm/dd'
            }).on('changeDate', function (selected) {
                startDate = new Date(selected.date.valueOf());
                startDate.setDate(startDate.getDate(new Date(selected.date.valueOf())));
                $('.to' + index).datepicker('setStartDate', startDate);
            });

            $('.to' + index).datepicker({
                autoclose: true,
                minDate: 0,
                format: 'yyyy/mm/dd'
            }).on('changeDate', function (selected) {
                FromEndDate = new Date(selected.date.valueOf());
                FromEndDate.setDate(FromEndDate.getDate(new Date(selected.date.valueOf())));
                $('.from' + index).datepicker('setEndDate', FromEndDate);
            });

        });
    }
    //get current date
    n = new Date();
    y = n.getFullYear();
    m = n.getMonth() + 1;
    d = n.getDate();
    $('#date').val(y + "/" + m + "/" + d);
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/1.5.1/socket.io.js"></script>
<script>
    var socket = io.connect('http://test2.snsreport.addix.tokyo:8890');
    var per_current = 0;
    // var key_current = 0;
    var bar = $(".progress-bar-inner");
    bar.css("font-size", 15);
    bar.css('color', '#ffffff');
    var id_percent = document.getElementById("percent");
    var id_user = document.getElementById("userID").value;
    socket.on('message', function (data) {
        data = jQuery.parseJSON(data);
        if(data.userID == id_user){
            console.log('*** id_user: ' + id_user);
            console.log('*** data.userID: ' + data.userID);
            console.log('*** Percent progress: ' + data.percent);
            for(i = per_current; i < data.percent; i++){
                var per = i+1;
                bar.css("width", per + "%");
                bar.css("text-align", 'center');
                id_percent.innerHTML = per + "%";
            }
            per_current = data.percent;
            // key_current++;
        }
    });
</script>

@endpush
