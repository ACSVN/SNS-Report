@extends('dashboard')
@section('content')
<div class="box-body">
  <a href="#" class="btn btn-primary" id="addNew"><i class="fa fa-plus"></i> Add new groups</a>
  <table id="list_groups" class="table table-bordered table-striped">
      <thead>
          <tr>
              <th>Group ID</th>
              <th>Group Name</th>
              <th>Delete</th>
              <th>Action</th>
          </tr>
      </thead>
  </table>
</div>
@endsection
@push('scripts-footer')
<style type="text/css">
  #list_groups_wrapper{
    margin-top: 1%;
  }
  table#list_groups>tbody>tr>td:last-child{
    text-align: center;
  }
</style>
<script>
$(document).ready(function() {


  var table = $('#list_groups').DataTable( {
      "processing": true,
      "pageLength": 100,
      "ajax": "{{action('UserController@getGroup')}}",
      "columns": [
          { "data": "id" },
          { "data": "group_name" },
          { "data": "deleted_at" }
      ],
      "columnDefs":[
            { 
                "targets": 3,
                "render": function( data, type, row ) {
                    return '<button data-consignmentId="'+data+'" class="btn btn-info editBtn"><i class="fa fa-edit"></i> Edit</button> ' ;
                    // '<button data-consignmentId="'+data+'" class="btn btn-warning removeBtn">Remove</button>';            
                }
            },
            {
                "targets": 2,
                "visible": false
            }
        ]
        ,
        "rowCallback": function( row, data, index ) {
            if (data.deleted_at){
                $('td', row).css('background-color', 'Red');
                $('td', row).css('color', '#FFFFFF');
            }
        }
  } );

  $('#addNew').on( 'click', function () {
      window.location.href = "/user/addGroup";
  });

  $('#list_groups tbody').on('click', '.editBtn', function() {
      var data = table.row( $(this).parents('tr') ).data();
      var groupId = data['id'];
      window.location.href = "/user/editGroup/"+groupId;
  })

  // $('#list_groups tbody').on('click', '.removeBtn', function() {
  //     var data = table.row( $(this).parents('tr') ).data();
  //     var groupId = data['id'];
  //     if(data['deleted_at']){
  //       alert('This user already removed.')
  //     }else{
  //       $.ajaxSetup({
  //           headers: {
  //               'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
  //           }
  //       })
  //       $.ajax({
  //           type: "POST",
  //           url: '/user/deleteGroup',
  //           dataType:'json',
  //           data: {'groupId':groupId},
  //           success: function(data) {
  //             window.location.href = "/user/manageListGroup";
  //           }
  //       })
  //     }
  // })
} );
FB.ui({
  method: 'pagetab',
  redirect_uri: 'http://socialmediamanagement.dev/'
}, function(response){});
FB.login(function(response) {
    if (response.authResponse) {
     console.log('Welcome!  Fetching your information.... ');
     FB.api('/me', function(response) {
       console.log('Good to see you, ' + response.name + '.');
     });
    } else {
     console.log('User cancelled login or did not fully authorize.');
    }
});
</script>
@endpush
