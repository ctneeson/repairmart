<div id="listings-grid">
    <table>
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
                    <td>{{ $listing['listingTitle'] }}</td>
                    <td>{{ $listing['currencyISO'] }}</td>
                    <td>{{ $listing['listingBudget'] }}</td>
                    <td>{{ $listing['listingExpiryDate'] }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
    {{ $listings->links() }}
</div>