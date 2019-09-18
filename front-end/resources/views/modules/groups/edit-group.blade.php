@extends('dashboard')
@section('content')
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <div class="box-body">
        {!! Form::open(['url' => route('saveGroup'), 'class' => 'form-horizontal form-edit-group', 'id' => 'form-edit-group'] ) !!}
        <h2 class="text-center">Edit Group</h2>
        <p id="alert_msg_2">{{ isset($msg_err) ? $msg_err : '' }}</p>
        <hr noshade>
        <div class="form-group">
          <label class="control-label col-sm-4">Group ID: </label> 
          <div class="col-sm-1">
            <input class="form-control"
                   id="inputGroupID"
                   name="groupID" value="{{$detail_group['id']}}"
                   type="text" disabled="true">
            <input class="form-control"
             id="inputGroupID"
             name="groupID" value="{{$detail_group['id']}}"
             type="hidden">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4">Group Name: </label>
          <div class="col-sm-4">
            <input class="form-control"
                   required
                   id="inputGroupName"
                   name="groupName" value="{{$detail_group['group_name']}}"
                   type="text">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4" for="inputActive">Active: </label>
          <div class="col-sm-4">
            <label class="radio-inline"><input <?php if (empty($detail_group['deleted_at'])) echo "checked";?> value="" type="radio" name="deleted_flg">Active</label>
            <label class="radio-inline"><input <?php if (!empty($detail_group['deleted_at'])) echo "checked";?> value="1" type="radio" name="deleted_flg">Deactive</label>
          </div>
        </div>

        <div class="form-group">        
          <div class="col-sm-offset-4 col-sm-10">
            <button class="btn btn-success">Save</button>
          </div>
          <div class="alert alert-warning alert-dismissible fade in" style="display: none;">
              Please fill out these input!
          </div>
        </div>
      
        {!! Form::close() !!}
    </div>
@endsection
@push('scripts-footer')
@include('partials/script')
@include('partials/css')
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/css/bootstrap-datepicker3.css"/>
<script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.4.1/js/bootstrap-datepicker.min.js"></script>
<script type="text/javascript">
document.getElementById("form-edit-group").onsubmit = function () {
    if (!document.getElementById("inputGroupName").value) {
        $(".alert-warning").show('medium');
        return false;
    }else{
        $(".alert-warning").hide();
    }
}
</script>
<style type="text/css">
  #alert_msg_2{
    color: red;
    margin: 0 auto;
    width: 22%;
  }
</style>
@endpush
