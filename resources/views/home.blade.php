@extends('layouts.layout')

@section('head')
<title>Home</title>
@endsection

@section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart</p>
@endsection

@section('content')
    <img src="/img/soldering-iron-icon.png" alt="RepairMart Logo" class="center">
    <div>
        <div class="home_search">
            <span>Search</span>
            <input class="home_search_textinput" type="text" placeholder="Enter text..">
            <button class="home_search_button">Go</button>
        </div>
        <a href="/listings/create" class="home_link">Create Listing</a>
    </div>

    @include('partials.listings-grid', ['listings' => $listings])
@endsection
