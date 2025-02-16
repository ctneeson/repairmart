@extends('layouts.layout')

@section('head')
<title>Logout</title>
@endsection

@section('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const logoutUrl = 'http://127.0.0.1:8000/api/logout';
        const token = localStorage.getItem('api_token');

        if (token) {
            fetch(logoutUrl, {
                method: 'POST',
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    localStorage.removeItem('api_token');
                    window.location.href = 'http://localhost:8080';
                } else {
                    console.error('Logout failed');
                }
            })
            .catch(error => console.error('Error during logout:', error));
        } else {
            window.location.href = 'http://localhost:8080';
        }
    });
</script>
@endsection