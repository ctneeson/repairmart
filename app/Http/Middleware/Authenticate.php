<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class Authenticate extends Middleware
{
    /**
     * Get the path the user should be redirected to when they are not authenticated.
     */
    protected function redirectTo(Request $request): ?string
    {
        Log::info('Authenticate Middleware: Handling request', [
            'url' => $request->url(),
            'headers' => $request->headers->all(),
            'body' => $request->all()
        ]);

        if (!$this->auth->check()) {
            Log::info('User is not authenticated');
        } else {
            Log::info('User is authenticated');
        }

        return $request->expectsJson() ? null : route('login');
    }
}