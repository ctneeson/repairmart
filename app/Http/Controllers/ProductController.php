<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ProductController extends Controller
{
    public function index()
    {
        // Define the API URL
        $apiUrl = config('api.url') . '/product-classifications';

        // Make a GET request to the API with the authorization token
        $response = Http::withToken(auth()->user()->api_token)->get($apiUrl);

        // Check if the request was successful
        if ($response->successful()) {
            $data = $response->json()['data'];
        } else {
            // Handle the error
            $data = [];
        }

        // Return the data as a JSON response
        return response()->json([
            'data' => $data,
        ]);
    }
}