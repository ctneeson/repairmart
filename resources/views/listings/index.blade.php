@extends('layouts.layout')

@section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart Listings.</p>
@endsection

@section('content')
    <div>
    @foreach($listings as $listing)
        <!-- @if($loop->first)
            <span>Here are the Listings:</span>
        @endif
            <div>{{$listing['id'].': '.$listing['title']}}</div>
            <div>Price: {{$listing['price']}}</div>
            <div>Description: {{$listing['description']}}</div>
        @if($loop->last)
            <span>That is all.</span>
        @endif -->
        <div>
            {{ $listing->listingId }}: {{ $listing->listingTitle }}
        </div>
    @endforeach
    </div>
@endsection