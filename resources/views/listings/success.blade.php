<!DOCTYPE html>
<html>
<head>
    <title>Success</title>
    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function() {
            alert('{{ $message }}');
            window.location.href = '{{ $redirectUrl }}';
        });
    </script>
</head>
<body>
</body>
</html>