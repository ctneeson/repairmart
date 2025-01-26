<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Listing;

class ListingController extends Controller
{
    //function for '/listings' route
    public function index() {
        // $listings = [
        //     ['id' => 1, 'title' => 'First Listing', 'price' => '1.00', 'description' => 'This is the description for the first listing'],
        //     ['id' => 2, 'title' => 'Second Listing', 'price' => '2.00', 'description' => 'This is the description for the second listing'],
        //     ['id' => 3, 'title' => 'Third Listing', 'price' => '3.00', 'description' => 'This is the description for the third listing'],
        // ];

        // $listings = Listing::all();
        // $listings = Listing::orderBy('DATE_INSERTED', 'desc')->get();
        $listings = Listing::where('listingStatusId', '=', 1)->orderBy('DATE_INSERTED', 'desc')->get();

        return view('listings', ['listings' => $listings]);
    }

    public function show($id) {
        return view('listingdetail', ['id' => $id]);
    }
}
