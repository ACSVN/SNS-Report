@extends('dashboard') @section('content')
<div class="row">
    <div class="col-md-12">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Link Account</h3>
            </div>

            <!-- facebook fields -->
            <div class="box-body col-md-6">
                @if(isset($facebook_accounts))
                    {!! Form::open(['url' => route('selectedAccount'),'class'=>'form-inline']) !!}
                        <div class="form-group">
                            {!! Form::label('select', 'Facebook Email', ['class' => 'control-label'] ) !!}
                            <select required="required" class="form-control" name="socialEmail" id="socialEmail">
                                @foreach ($facebook_accounts as $facebook_account)
                                    <option value="{{ $facebook_account['email'] }}">{{ $facebook_account['email'] }}
                                    </option>
                                @endforeach
                            </select>

                        </div>
                        {!! Form::submit('Choose Account', ['class' => 'btn btn-info','id'=>'chooseAccount'] ) !!}

                    {!! Form::close() !!}
                    <div class="box-header with-border">
                        @foreach($facebook_accounts as $facebook_account)
                            <h4>
                                <a href="{{ action('FacebookController@unlink', ['email' => $facebook_account['email']]) }}">
                                  Unlink This Email <?= $facebook_account['email'] ?>
                                </a>
                          </h4>
                        @endforeach
                    </div>
                @endif
                    <div class="box-header">
                        <h4>
                            <a href="<?= $facebookLoginUrl ?>"> Add New Facebook Account</a>
                        </h4>
                    </div>
            </div>
            <!-- end of facebook fields -->

            <!-- twitter fields -->
            <div class="box-body col-md-6">
                @if(!empty($twitter_accounts))
                    {!! Form::open(['url' => route('selectedAccount'),'class'=>'form-inline']) !!}
                    <div class="form-group">
                        {!! Form::label('select', 'Twitter Email', ['class' => 'control-label'] ) !!}
                        <select required="required" class="form-control" name="socialEmail" id="socialEmail">
                            @foreach ($twitter_accounts as $twitter_account)
                                <option value="{{ $twitter_account['email'] }}">{{ $twitter_account['email'] }}
                                </option>
                            @endforeach
                        </select>

                    </div>
                    {!! Form::submit('Choose Account', ['class' => 'btn btn-info','id'=>'chooseAccount'] ) !!}

                    {!! Form::close() !!}
                    <div class="box-header with-border">
                        @foreach($twitter_accounts as $twitter_account)
                            <h4>
                                <a href="{{ action('TwitterController@unlink', ['email' => $twitter_account['email']]) }}">
                                       Unlink This Email <?= $twitter_account['email'] ?>
                                </a>
                            </h4>
                        @endforeach
                    </div>
                @endif


                {{--@if(isset($authorizationUrl))--}}
                <div class="box-header">
                    <h4>
                        <a href="#"> Add New Twitter Account</a>
                    </h4>
                </div>
                {{--@endif--}}
            </div>
            <!-- end of twitter fields -->
        </div>
    </div>
</div>
@endsection @push('scripts-footer')
<script type="text/javascript">
    $(document).ready(function() {
        $("#chooseAccount").click(function() {
            var idCur = $("select#socialEmail").val();
        });
    });
</script>
@endpush
