@extends('dashboard')

@section('content')
<div class="row">
    <div class="col-md-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Update profile</h3>
            </div>
            <!-- form start -->
            {!! Form::open(['action' => 'UserController@store', 'id' => 'user-form']) !!}
                @include('modules.accounts._form', ['btnText' => 'Create'])
            {!! Form::close() !!}
            <!-- form end -->
        </div>
    </div>
</div>
@endsection
