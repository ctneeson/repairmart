<div class="wrapper listings-index">
    <h1>Listings</h1>
    <table class="listings-table">
        <thead>
            <tr>
                <th>Listing Title</th>
                <th>Currency</th>
                <th>Budget</th>
                <th>Expiry Date</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($listings as $listing)
                <tr>
                    <td><a href="/listings/{{ $listing['listingId'] }}">{{ $listing['listingTitle'] }}</a></td>
                    <td>{{ $listing['currencyISO'] }}</td>
                    <td>{{ $listing['listingBudget'] }}</td>
                    <td>{{ $listing['listingExpiryDate'] }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
    {{ $listings->links() }}
</div>