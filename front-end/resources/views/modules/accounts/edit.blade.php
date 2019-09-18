<div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
    <h4 class="modal-title">Update profile</h4>
</div>
<div class="modal-body">
    <!-- form start -->
    {!! Form::model($user, ['action' => 'UserController@editProfile', 'id' => 'user-form']) !!}
        @include('modules.accounts._form', ['btnText' => 'Update'])
    {!! Form::close() !!}
    <!-- form end -->
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
    <button type="button" class="btn btn-primary" onClick="update()">Update</button>
</div>
