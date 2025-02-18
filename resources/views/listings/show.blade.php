@extends('layouts.layout')

@section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart Listings.</p>
@endsection

@section('content')
<div class="wrapper listing-details">
    <h1>{{ $listing['listingTitle'] }}</h1>
    <p>Detail: {{ $listing['listingDetail'] }}</p>
    <p>Manufacturer: {{ $listing['manufacturerName'] }}</p>
    <p>Budget: {{ $listing['currencyISO'] }} {{ $listing['listingBudget'] }}</p>
    <p>Expiry: {{ $listing['listingExpiryDate'] }}</p>
    <p>Created by: {{ $listing['name'] }}</p>
    <a href="/listings" class="back">Back to Listings</a>
</div>
@endsection