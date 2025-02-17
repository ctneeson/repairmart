<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Validator;

class RegisterController extends Controller
{
    public function showRegistrationForm()
    {
        return view('auth.register');
    }

    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'user_type' => 'required|in:1,2',
        ]);

        if ($validator->fails()) {
            return redirect()->back()->withErrors($validator)->withInput();
        }

        $response = Http::post('http://127.0.0.1:8000/api/register', [
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password,
            'c_password' => $request->password_confirmation,
            'accountTypeId' => $request->user_type,
        ]);

        if ($response->successful()) {
            // Handle successful registration
            return redirect()->route('login')->with('status', 'Registration successful. Please log in.');
        } else {
            // Handle registration failure
            return redirect()->back()->withErrors(['error' => 'Registration failed. Please try again.'])->withInput();
        }
    }
}
