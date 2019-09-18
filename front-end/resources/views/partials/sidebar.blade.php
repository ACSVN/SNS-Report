<aside class="main-sidebar">
  <!-- sidebar: style can be found in sidebar.less -->
  <section class="sidebar">
    <!-- Sidebar user panel -->
    <div class="user-panel">
      <div class="pull-left image">
      @if(Session::get('imageData'))
        <img src="data:image/jpeg;base64,<?= Session::get('imageData') ?>" class="img-circle" alt="User Image">
      @else 
        <img src="{{ asset(IMG.'/person1.png') }}" class="img-circle" alt="User Image">
      @endif
      </div>
      <div class="pull-left info">
        <p>{{Auth::user()->name}}</p>
        <a href="<?php getenv('APP_URL') ?>"><i class="fa fa-circle text-success"></i>Online</a>
      </div>
    </div>
   {{--  <!-- search form -->
    <form action="#" method="get" class="sidebar-form">
      <div class="input-group">
        <input type="text" name="q" class="form-control" placeholder="Search...">
            <span class="input-group-btn">
              <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
              </button>
            </span>
      </div>
    </form>
    <!-- /.search form --> --}}
    <!-- sidebar menu: : style can be found in sidebar.less -->
    <ul class="sidebar-menu">
      <li class="header">MAIN FUNCTION</li>
      <li class="treeview {{ Request::is('user/accounts')?'active':'' }}" >
        <a href="{{ action('UserController@social') }}">
          <i class="fa fa-dashboard"></i> <span>Link social account</span>
        </a>
      </li>
      @if (Session::get('socialEmail'))
      <li class="treeview {{ Request::is('user/pageList')?'active':'' }}">
        <a href="{{ action('UserController@index') }}">
          <i class="fa fa-th"></i> <span>Page List</span>
        </a>
      </li>
      @endif
      <li class="treeview">
        <a href="#" class="profile">
          <i class="fa fa-edit"></i> <span>Update Your Profile</span>
        </a>
      </li>
      @if(Session::get('role_id')==1)
      <li class="header">ADMIN FUNCTION</li>
      <li class="treeview {{ Request::is('user/manageListAccounts')?'active':'' }}" >
        <a href="{{ action('UserController@getListAccounts') }}">
          <i class="fa fa-user-plus"></i> <span>Manage List Accounts</span>
        </a>
      </li>
      <li class="treeview {{ Request::is('user/manageListGroup')?'active':'' }}" >
        <a href="{{ action('UserController@getGroup') }}">
          <i class="fa fa-users"></i> <span>Manage List Group/Team</span>
        </a>
      </li>
      @endif
    </ul>
  </section>
  <!-- /.sidebar -->
</aside>
