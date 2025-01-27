@extends('layouts.layout')

@section('title')
    <h1>RepairMart</h1>
    <p>Welcome to RepairMart Listings.</p>
@endsection

@section('content')
<div class="wrapper create-listing">
    <h2>Create New Listing</h2>
    <form action="/listings" method="post">
        @csrf
        <label for="title">Title:</label>
        <input type="text" required id="title" name="title">
        <label for="status">Manufacturer:</label>
        <input type="text" list="manufacturer" />
        <datalist id="manufacturer" name="manufacturer">
            <option>Acer</option>
            <option>Apple</option>
            <option>Microsoft</option>
            <option>Sony</option>
        </datalist>
        <label for="budget">Budget:</label>
        <select name="currency" id="currency">
            <option value="EUR">EUR</option>
            <option value="GBP">GBP</option>
            <option value="USD">USD</option>
        </select>
        <!-- <datalist id="currency" name="currency">
            <option>EUR</option>
            <option>GBP</option>
            <option>USD</option>
        </datalist> -->
        <input type="number" id="budget" name="budget" min="0" value="0" step=".01">
        <label for="detail">Detail:</label>
        <textarea id="detail" name="detail"></textarea>
        <input type="submit" value="Create Listing">
    </form>
</div>
@endsection