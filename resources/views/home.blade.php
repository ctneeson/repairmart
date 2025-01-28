@extends('layouts.layout')

@section('head')
<title>Home</title>
@endsection

@section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart, {{$name}}.</p>
@endsection

@section('content')
    <!-- <p>Welcome, {{$userName}}</p> -->
    <img src="/img/soldering-iron-icon.png" alt="RepairMart Logo" class="center">
    <div>
        <div class="home_search">
            <span>Search</span>
            <input class="home_search_textinput" type="text" placeholder="Enter text..">
            <button class="home_search_button">Go</button>
        </div>
        <a href="/listings/create" class="home_link">Create Listing</a>
    </div>
    <!-- @if ($loggedIn == true)
        <p>You are logged in.</p>
    @endif -->

    <!-- @for($i=0; $i < count($beatles); $i++)
        <p>{{ $beatles[$i]['firstName'].' '.$beatles[$i]['lastName'] }}</p>
    @endfor -->

    <!-- @foreach($beatles as $beat)
    @if($loop->first)
        <span>Here are the Fab Four:</span>
    @endif
    <div>{{$loop->index}}: {{ $beat['firstName'].' '.$beat['lastName'] }}</div>
    @if($loop->last)
        <span>Thank you. You've been a great audience...</span>
    @endif
    @endforeach -->
@endsection