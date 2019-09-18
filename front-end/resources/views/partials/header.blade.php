<meta name="csrf-token" content="{{ csrf_token() }}">
<header class="main-header">
  <!-- Logo -->
  <a href="<?php getenv('APP_URL') ?>" class="logo">
    <!-- mini logo for sidebar mini 50x50 pixels -->
    <span class="logo-mini"><b>S</b>P</span>
    <!-- logo for regular state and mobile devices -->
    <span class="logo-lg"><b>SNS</b>Project</span>
  </a>
  <!-- Header Navbar: style can be found in header.less -->
  <nav class="navbar navbar-static-top">
    <!-- Sidebar toggle button-->
    <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
      <span class="sr-only">Toggle navigation</span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </a>

    <div class="navbar-custom-menu">
      <ul class="nav navbar-nav">
        <!-- User Account: style can be found in dropdown.less -->
        <li class="dropdown user user-menu">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            @if(Session::get('imageData'))
              <img src="data:image/jpeg;base64,<?= Session::get('imageData') ?>" class="user-image" alt="User Image">
            @else 
              <img src="{{ asset(IMG.'/person1.png') }}" class="user-image" alt="User Image">
            @endif
            <span class="hidden-xs">{{Auth::user()->name}}</span>
          </a>
          <ul class="dropdown-menu">
            <!-- User image -->
            <li class="user-header">
              @if(Session::get('imageData'))
                <img src="data:image/jpeg;base64,<?= Session::get('imageData') ?>" class="img-circle" alt="User Image">
              @else 
                <img src="{{ asset(IMG.'/person1.png') }}" class="img-circle" alt="User Image">
              @endif
              <p>
                {{Auth::user()->name}}
                <small>{{Auth::user()->email}}</small>
              </p>
            </li>
            <!-- Menu Body -->

            <!-- Menu Footer-->
            <li class="user-footer">
              <div class="pull-left">
                <button data-toggle="modal"
                    class="btn btn-default btn-flat profile">Profile</button>
              </div>
              <div class="pull-right">
                <a href="{{ route('user_logout') }}" class="btn btn-default btn-flat">Sign out</a>
              </div>
            </li>
          </ul>
        </li>

      </ul>
    </div>
  </nav>
</header>

@push('scripts-footer')
    <script>
        $('.profile').click(function() {
            $.ajaxSetup({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                }
            })
            $.ajax({
                url: '{{ action("UserController@editProfile") }}',
                success: function(data) {
                    $('.modal-content').html(data)
                }
            }).done(function() {
                $('#myModal').modal()
                $('#user-form').parsley().on
            })
        })
    </script>
@endpush
