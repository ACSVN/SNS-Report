@extends('dashboard')
@section('content')
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <div class="box-body">
        {!! Form::open(['url' => route('addNewAccount'), 'class' => 'form-horizontal form-add-user', 'id' => 'form-add-user'] ) !!}
        <h2 class="text-center">Add User</h2>
        <p id="alert_msg">{{ isset($msg_err) ? $msg_err : '' }}</p>
        <hr noshade>
        <div class="form-group">
          <label class="control-label col-sm-4">User ID: </label> 
          <div class="col-sm-1">
            <input class="form-control"
                   id="inputUserID"
                   name="userID" value=""
                   type="text" disabled="true">
            <input class="form-control"
             id="inputUserID"
             name="userID" value=""
             type="hidden">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4">User Name: </label>
          <div class="col-sm-4">
            <input class="form-control"  placeholder="User name here." 
                   required
                   id="inputUserName"
                   name="userName" value=""
                   type="text">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4">Email: </label>
          <div class="col-sm-4">
            <input class="form-control" placeholder="User email here." 
                   required
                   id="inputEmail"
                   name="email" value="">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4">Password: </label>
          <div class="col-sm-4">
            <input class="form-control" placeholder="User password here." 
                   required
                   id="inputPassword"
                   name="password" value=""
                   type="password">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4">Role: </label>
          <div class="col-sm-4">
          <label class="radio-inline"><input required type="radio" value="1" name="admin_flg">Admin</label>
          <label class="radio-inline"><input type="radio" value="" name="admin_flg">User</label>
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4">Group/Team: </label>
          <div class="col-sm-4">
          <select id="group_id"  name="group_id" class="form-control">
              @foreach ($list_group as $l)
                <option value="{{ $l['id'] }}">{{ $l['group_name'] }}</option>
              @endforeach
          </select>
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4" for="inputActive">Active: </label>
          <div class="col-sm-4">
            <label class="radio-inline"><input required value="" type="radio" name="deleted_flg">Active</label>
            <label class="radio-inline"><input value="1" type="radio" name="deleted_flg">Deactive</label>
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
document.getElementById("form-add-user").onsubmit = function () {
    if (!document.getElementById("inputUserName").value || !document.getElementById("inputEmail").value || !document.getElementById("inputPassword").value) {
        $(".alert-warning").show('medium');
        return false;
    }else{
        $(".alert-warning").hide();
    }
}
</script>
@endpush
