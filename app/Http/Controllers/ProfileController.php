<?php

namespace App\Http\Controllers;

use App\Http\Requests\ProfileUpdateRequest;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Log;
use Illuminate\View\View;

class ProfileController extends Controller
{
    /**
     * Display the user's profile form.
     */
    public function edit(Request $request): View
    {
        Log::info('ProfileController: edit method called');

        $token = $request->user()->token;

        // Log the token for debugging
        Log::info('User Token:', ['token' => $token]);

        // Make a GET request to the API to retrieve the user's profile information
        $response = Http::withToken($token)->get('http://127.0.0.1:8000/api/user');

        // Log the API response
        Log::info('API Response:', $response->json());

        if ($response->successful()) {
            $user = $response->json();
            return view('profile.edit', ['user' => $user]);
        } else {
            // Handle the error
            return redirect()->back()->withErrors(['error' => 'Failed to retrieve profile information.']);
        }
    }

    /**
     * Update the user's profile information.
     */
    public function update(ProfileUpdateRequest $request): RedirectResponse
    {
        $token = $request->user()->token;

        // Make a PUT request to the API to update the user's profile information
        $response = Http::withToken($token)->put('http://127.0.0.1:8000/api/user', $request->validated());

        // Log the API response
        Log::info('API Response:', $response->json());

        if ($response->successful()) {
            return Redirect::route('profile.edit')->with('status', 'profile-updated');
        } else {
            // Handle the error
            return redirect()->back()->withErrors(['error' => 'Failed to update profile information.']);
        }
    }

    /**
     * Delete the user's account.
     */
    public function destroy(Request $request): RedirectResponse
    {
        $token = $request->user()->token;

        // Validate the password
        $request->validateWithBag('userDeletion', [
            'password' => ['required', 'current_password'],
        ]);

        // Make a DELETE request to the API to delete the user's account
        $response = Http::withToken($token)->delete('http://127.0.0.1:8000/api/user');

        // Log the API response
        Log::info('API Response:', $response->json());

        if ($response->successful()) {
            Auth::logout();

            $request->session()->invalidate();
            $request->session()->regenerateToken();

            return Redirect::to('/');
        } else {
            // Handle the error
            return redirect()->back()->withErrors(['error' => 'Failed to delete account.']);
        }
    }
}