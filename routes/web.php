<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ListingController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});


Route::get('/login', function () {
    return view('login');
});

Route::get('/dashboard', function () {
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';

///////////////////
// New additions //
///////////////////

// Route::get('/home', function () {
//     $beatles = [
//         ['firstName' => 'John', 'lastName' => 'Lennon'],
//         ['firstName' => 'Paul', 'lastName' => 'McCartney'],
//         ['firstName' => 'George', 'lastName' => 'Harrison'],
//         ['firstName' => 'Ringo', 'lastName' => 'Starr']
//     ];
//     $user = ['userName' => 'RepairMart', 'loggedIn' => false, 'beatles' => $beatles];

//     return view('home', $user, ['name' => request('name')]);
// });

Route::get('/home', [ListingController::class, 'index']);

Route::get('/listings', [ListingController::class, 'index']);
Route::get('/listings/create', [ListingController::class, 'create']);
Route::post('/listings', [ListingController::class,'store']);
Route::get('/listings/{id}', [ListingController::class, 'show']);
