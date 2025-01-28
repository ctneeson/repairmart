<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
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

        $category = $request->input('category[]');

        Log::info('Stored Procedure Input:', $category);

/*        // Define the input parameters
        $params = [
            $request->input('userId'),
            $request->input('listingStatusId'),
            $request->input('manufacturerId'),
            $request->input('listingTitle'),
            $request->input('listingBudgetCurrencyId'),
            $request->input('listingBudget'),
            $request->input('useDefaultLocation'),
            $request->input('overrideAddressLine1'),
            $request->input('overrideAddressLine2'),
            $request->input('overrideCountryId'),
            $request->input('overridePostCode'),
            $request->input('listingExpiry'),
            $request->input('attachmentUrlList'),
            $request->input('attachmentHashList'),
            $request->input('attachmentOrderList'),
            $request->input('productClassificationIdList'),
        ];

        // Define the output parameters
        $outputParams = [
            '@ins_rows' => 0,
            '@ins_rows_attachments' => 0,
            '@ins_rows_classifications' => 0,
            '@ERR_MESSAGE' => '',
            '@ERR_IND' => 0,
            '@out_runId' => 0,
            '@out_listingId' => 0,
        ];

        // Prepare the SQL statement with placeholders for input and output parameters
        $sql = 'EXEC sp_postNewListing ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 
                @ins_rows OUTPUT, @ins_rows_attachments OUTPUT, @ins_rows_classifications OUTPUT, 
                @ERR_MESSAGE OUTPUT, @ERR_IND OUTPUT, @out_runId OUTPUT, @out_listingId OUTPUT';

        // Execute the stored procedure
        $result = DB::statement($sql, array_merge($params, array_values($outputParams)));

        // Log the output parameters
        Log::info('Stored Procedure Output:', $outputParams);

        // Handle the output parameters as needed
        if ($outputParams['@ERR_IND'] == 1) {
            return response()->json(['error' => $outputParams['@ERR_MESSAGE']], 400);
        }
*/
        // return redirect('/home')->with('success', 'Listing created successfully');
        // return redirect('/listings')->with('mssg', 'Listing created successfully');
        return view('listings.success', ['message' => 'Listing created successfully', 'redirectUrl' => '/listings']);
    }
}
