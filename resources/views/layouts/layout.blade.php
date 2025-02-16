<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/main.css" rel="stylesheet">
    <link href="https://fonts.cdnfonts.com/css/koulen" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">
    @yield('scripts')
    @yield('head')
</head>
<header class="navbar">
    @yield('nav')
</header>
<body>
    @yield('content')
</body>
<footer id="footer">
    <p>&copy; 2020 My Laravel App</p>
</footer>
</html>
