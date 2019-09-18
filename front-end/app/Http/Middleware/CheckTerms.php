<?php

namespace App\Http\Middleware;

use Closure;
use Auth;
class CheckTerms
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        if(Auth::user()->status == 0) {
            return redirect('terms/accept');
        }
        return $next($request);
    }
}
