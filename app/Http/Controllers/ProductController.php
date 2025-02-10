<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        // Define the API URL
        $apiUrl = 'http://127.0.0.1:8000/api/product-classifications';

        // Make a GET request to the API
        $response = Http::get($apiUrl);

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
