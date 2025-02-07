@extends('layouts.layout')

<!-- @section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart Listings.</p>
@endsection -->

@section('content')
    <h1>Listings</h1>
    @include('partials.listings-grid', ['listings' => $listings])
@endsection