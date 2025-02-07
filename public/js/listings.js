document.addEventListener("DOMContentLoaded", function () {
    const apiUrl = "http://127.0.0.1:8000/api/listings";
    const rowsPerPage = 20;
    let currentPage = 1;
    let totalPages = 1;

    function fetchListings(page) {
        fetch(`${apiUrl}?page=${page}&limit=${rowsPerPage}`)
            .then((response) => response.json())
            .then((data) => {
                if (data.success) {
                    renderListings(data.data);
                    totalPages = Math.ceil(data.data.length / rowsPerPage);
                    updatePagination();
                } else {
                    console.error("Failed to fetch listings:", data.message);
                }
            })
            .catch((error) => console.error("Error fetching listings:", error));
    }

    function renderListings(listings) {
        const tbody = document.getElementById("listings-body");
        tbody.innerHTML = "";

        listings.forEach((listing) => {
            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${listing.listingTitle}</td>
                <td>${listing.currencyISO}</td>
                <td>${listing.listingBudget}</td>
                <td>${listing.listingExpiryDate}</td>
            `;
            tbody.appendChild(row);
        });
    }

    function updatePagination() {
        document.getElementById(
            "page-info"
        ).textContent = `Page ${currentPage} of ${totalPages}`;
        document.getElementById("prev-page").disabled = currentPage === 1;
        document.getElementById("next-page").disabled =
            currentPage === totalPages;
    }

    document.getElementById("prev-page").addEventListener("click", function () {
        if (currentPage > 1) {
            currentPage--;
            fetchListings(currentPage);
        }
    });

    document.getElementById("next-page").addEventListener("click", function () {
        if (currentPage < totalPages) {
            currentPage++;
            fetchListings(currentPage);
        }
    });

    // Initial fetch
    fetchListings(currentPage);
});
