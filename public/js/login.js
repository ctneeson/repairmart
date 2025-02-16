document.addEventListener("DOMContentLoaded", function () {
    document
        .getElementById("login-form")
        .addEventListener("submit", function (event) {
            event.preventDefault();
            console.log("Form submission prevented");

            const formData = new FormData(this);
            const loginUrl = "http://127.0.0.1:8000/api/login";

            fetch(loginUrl, {
                method: "POST",
                body: formData,
                headers: {
                    Accept: "application/json",
                },
            })
                .then((response) => response.json())
                .then((data) => {
                    console.log("API Response:", data); // Log the full response
                    if (data.data && data.data.token) {
                        localStorage.setItem("api_token", data.data.token);
                        // Redirect or perform other actions after successful login
                        console.log(
                            "Login successful, token stored:",
                            data.data.token
                        );
                        console.log("Redirecting to localhost:8080");
                        window.location.href = "/"; // Redirect to dashboard or another page
                    } else {
                        console.error(
                            "Login failed:",
                            data.message || data.error
                        );
                    }
                })
                .catch((error) => console.error("Error during login:", error));
        });
});
