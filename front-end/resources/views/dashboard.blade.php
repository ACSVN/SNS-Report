<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>SNS Project</title>
  @include('partials/css')
</head>
<body class="hold-transition skin-red-light sidebar-mini">
<!-- Site wrapper -->
<div class="wrapper">

  @include('partials/header')

  <!-- =============================================== -->

  <!-- Left side column. contains the sidebar -->
  @include('partials/sidebar')

  <!-- =============================================== -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <?php if(Auth::user()->refresh_token){?>
          <small>
            <a href="{{ action('FacebookController@unlink') }}">Unlink Your Social Account</a>
          </small>
        <?php }?>
      </h1>
      {{-- @include('partials/breadcrumb') --}}
    </section>

    <!-- Main content -->
    <section class="content">
        @yield('content')
    </section>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->
  @include('partials/modal')
  @include('partials/footer')

</div>
<!-- ./wrapper -->

<!-- lock report -->
<div id="box-lock-report" class="hidden">
    <!-- <i class="fa fa-spinner fa-spin fa-3x fa-fw"></i> -->
    <div class="progress-bar-bg" style=" /*display:none;*/ width: 40%; left: 38% !important; top: 60% !important;">
      <div class="progress-bar-inner" id="percent" style=""></div>
    </div>
</div>
<!-- ./lock report -->

@include('partials/script')
@include('partials/flash-message')
@stack('scripts-footer')

<script type="text/javascript">
var update = function(e){
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    })

    if(!$('#user-form').parsley().isValid()) return;

    $.ajax({
        url: '{{ action("UserController@updateProfile") }}',
        method: "POST",
        data: $('#user-form').serialize(),
        success: function(data) {
            (data == 1) ? window.location.href = "{{ action('UserController@index') }}" : $('#myModal').modal('hide')
        }
    }).done(function() {

    })
}
</script>
</body>
</html>
