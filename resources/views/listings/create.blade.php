@extends('layouts.layout')

@section('head')
<title>Create Listing</title>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            const categories = {
                'Arts, Crafts & Sewing': ['Printing Presses & Accessories', 'Sewing Machines', 'Other-Misc.'],
                'Audio-Visual': ['Audio Headphones & Accessories', 'Blu-ray Players & Recorders', 'Cassette Players & Recorders', 'CB & Two-Way Radios', 'CD Players', 'Compact Radios & Stereos', 'Digital Voice Recorders', 'DVD Players & Recorders', 'Home Theater Systems', 'MP3 & MP4 Players', 'Radios', 'Satellite Television Products', 'Speakers & Audio Systems', 'Streaming Media Players', 'Televisions']
            };

            let fieldsetCount = 1;

            function createFieldset() {
                const fieldset = document.createElement('fieldset');
                fieldset.innerHTML = `
                    <legend>Product Type ${fieldsetCount}:</legend>
                    <label for="category${fieldsetCount}">Category:</label>
                    <select id="category${fieldsetCount}" name="category[]">
                        <option value="">Select Category</option>
                    </select>

                    <label for="subcategory${fieldsetCount}">Subcategory:</label>
                    <select id="subcategory${fieldsetCount}" name="subcategory[]">
                        <option value="">Select Subcategory</option>
                    </select>
                `;

                document.getElementById('product-types').appendChild(fieldset);

                const categorySelect = document.getElementById(`category${fieldsetCount}`);
                const subcategorySelect = document.getElementById(`subcategory${fieldsetCount}`);

                // Populate categories
                for (const category in categories) {
                    const option = document.createElement('option');
                    option.value = category;
                    option.textContent = category;
                    categorySelect.appendChild(option);
                }

                // Handle category change
                categorySelect.addEventListener('change', function() {
                    const selectedCategory = categorySelect.value;
                    subcategorySelect.innerHTML = '<option value="">Select Subcategory</option>';

                    if (selectedCategory) {
                        categories[selectedCategory].forEach(function(subcategory) {
                            const option = document.createElement('option');
                            option.value = subcategory;
                            option.textContent = subcategory;
                            subcategorySelect.appendChild(option);
                        });
                    }
                });

                // Handle subcategory change
                subcategorySelect.addEventListener('change', function() {
                    const selectedSubcategory = subcategorySelect.value;

                    if (selectedSubcategory) {
                        for (const category in categories) {
                            if (categories[category].includes(selectedSubcategory)) {
                                categorySelect.value = category;
                                break;
                            }
                        }
                    }
                });

                fieldsetCount++;
            }

            document.getElementById('add-product-type').addEventListener('click', function() {
                if (fieldsetCount <= 3) {
                    createFieldset();
                } else {
                    alert('You can only add up to 3 product types.');
                }
            });

            // Create the initial fieldset
            createFieldset();
        });
    </script>
@endsection

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
        <input type="number" id="budget" name="budget" min="0" value="0" step=".01">
        <div id="product-types"></div>
        <button type="button" id="add-product-type">Add extra product type</button>
        <label for="detail">Detail:</label>
        <textarea id="detail" name="detail"></textarea>
        <input type="submit" value="Create Listing">
    </form>
</div>
@endsection