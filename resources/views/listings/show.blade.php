@extends('layouts.layout')

@section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart Listings.</p>
@endsection

@section('content')
<div class="wrapper listing-details">
    <h1>{{ $listing->listingTitle }}</h1>
    <p>Status: {{ $listing->listingStatusId }}</p>
    <p>Budget: {{ $listing->listingBudgetCurrencyId }} {{ $listing->listingBudget }}</p>
    <p>Created at: {{ $listing->DATE_INSERTED }}</p>
    <p>Created by: {{ $listing->userId }}</p>
    <a href="/home" class="back">Back to Listings</a>
</div>
@endsection