@if( $message = Session::get('success') )
    <script type="text/javascript">
        toastr.success('{{ $message }}', 'Success Alert', {timeOut: 5000, "positionClass": "toast-bottom-right",})
    </script>
@endif

@if( $message = Session::get('error') )
    <script type="text/javascript">
        toastr.error('{{ $message }}', 'Error Alert', {timeOut: 5000, "positionClass": "toast-bottom-right",})
    </script>
@endif

@if( $message = Session::get('warning') )
    <script type="text/javascript">
        toastr.warning('{{ $message }}', 'Warning Alert', {timeOut: 5000, "positionClass": "toast-bottom-right",})
    </script>
@endif
