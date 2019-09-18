<div class="box-body">
    <div class="row">
            <div class="col-md-12">
                <form class="form-horizontal">
                    <div class="form-group ">
                        {!! Form::label('', 'Name', ['class' => 'col-md-2 control-label']) !!}
                        <div class="col-md-10">
                            {!! Form::text('name', null, ['class' => 'form-control',
                                'placeholder' => 'Name',
                                'data-parsley-required' =>"true",
                                'data-parsley-trigger'=>"focusout"
                                ]) !!}
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
