@extends('dashboard')
@section('content')
<div class="box-body">
    <table id="social_accounts" class="table table-bordered table-striped">
        <thead>
            <tr>
                <th>Page ID</th>
                <th>Page Name</th>
                <th>Page Category</th>
                <th>Action</th>
            </tr>
        </thead>
    </table>
</div>
@endsection
@push('scripts-footer')
<script>
$(document).ready(function() {

  var table = $('#social_accounts').DataTable( {
      "processing": true,
      "pageLength": 100,
      "ajax": "{{ action('FacebookController@pages') }}",
      "columns": [
          { "data": "id" },
          { "data": "name" },
          { "data": "category" }
      ],
      "columnDefs": [ {
        "targets": 3,
        "data": "null",
        "render": function ( data, type, full, meta ) {
          return '<a href="#" class="btn btn-success"><i class="fa fa-area-chart"></i> Make Report</a>';
        }
      } ]
  } );

  $('#social_accounts tbody').on('click', 'a', function () {
      var data = table.row( $(this).parents('tr') ).data();
      var pageName = data['name'];
      var pageID = data['id'];
      $.ajaxSetup({
          headers: {
              'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
          }
      });
      $.ajax({
          type: "POST",
          url: '/report/create',
          dataType:'json',
          data: {'pageName':pageName,'pageID':pageID},
          success: function(data) {
              window.location.href = "/report/input";
          }
      })
  });
});
</script>
@endpush
