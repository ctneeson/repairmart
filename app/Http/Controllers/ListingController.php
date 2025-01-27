<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Listing;
use Illuminate\Support\Facades\Log;

class ListingController extends Controller
{
    //function for '/listings' route
    public function index() {
        // $listings = Listing::all();
        // $listings = Listing::orderBy('DATE_INSERTED', 'desc')->get();
        $listings = Listing::where('listingStatusId', '=', 1)->orderBy('DATE_INSERTED', 'desc')->get();

        // Call the stored procedure and get the result
        // $listing = DB::select('EXEC GetListingById ?', [$id]);
    
        // Check if the result is not empty and get the first element
        // if (!empty($listing)) {
        //     $listing = $listing[0];
        // } else {
            // Handle the case where no listing is found
        //     abort(404, 'Listing not found');
        // }

            return view('listings.index', ['listings' => $listings]);
        }

    public function show($id) {
        $listing = Listing::findOrFail($id);
        return view('listings.show', ['listing' => $listing]);
    }

    public function create() {
        return view('listings.create');
    }

    public function store(Request $request) {
        // $listing = new Listing();
        // $listing->listingName = $request->input('listingName');
        // $listing->listingDescription = $request->input('listingDescription');
        // $listing->listingPrice = $request->input('listingPrice');
        // $listing->listingStatusId = 1;
        // $listing->save();

        // Log the entire request data
        Log::info('Request Data: ' . json_encode($request->all()));
        return redirect('/home');
    }
}
