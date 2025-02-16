@extends('layouts.layout')

@section('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM fully loaded and parsed'); // Debugging log
        const authLinks = document.getElementById('nav-links');
        console.log('authLinks element:', authLinks); // Debugging log
        const token = localStorage.getItem('api_token');
        console.log('Token:', token); // Debugging log

        if (token) {
            authLinks.innerHTML = '<a href="/logout" class="home_link">Log Out</a>';
        } else {
            authLinks.innerHTML = '<a href="/login" class="home_link">Login</a><a href="/register" class="home_link">Sign Up</a>';
        }
    });
</script>
@endsection

@section('head')
<title>Home</title>
@endsection

@section('nav')
    <div id="nav-links">
        <!-- Links will be rendered by JavaScript -->
    </div>
@endsection

@section('content')
    <img src="/img/soldering-iron-icon.png" alt="RepairMart Logo" class="center">
    <div id="home-title">RepairMart</div>
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
