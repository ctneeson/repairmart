document.addEventListener("DOMContentLoaded", function () {
    const apiUrl = "http://127.0.0.1:8000/api/product-classifications";
    let categories = {};
    let fieldsetCount = 1;

    function fetchCategories() {
        fetch(apiUrl, {
            headers: {
                Authorization: "Bearer " + localStorage.getItem("api_token"),
            },
        })
            .then((response) => response.json())
            .then((data) => {
                if (Array.isArray(data.data)) {
                    data.data.forEach((item) => {
                        if (!categories[item.category]) {
                            categories[item.category] = [];
                        }
                        categories[item.category].push(item.subcategory);
                    });
                    createFieldset();
                } else {
                    console.error(
                        "Failed to fetch categories: data is not an array",
                        data
                    );
                }
            })
            .catch((error) =>
                console.error("Error fetching categories:", error)
            );
    }

    function createFieldset() {
        const fieldset = document.createElement("fieldset");
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

        document.getElementById("product-types").appendChild(fieldset);

        const categorySelect = document.getElementById(
            `category${fieldsetCount}`
        );
        const subcategorySelect = document.getElementById(
            `subcategory${fieldsetCount}`
        );

        // Populate categories
        for (const category in categories) {
            const option = document.createElement("option");
            option.value = category;
            option.textContent = category;
            categorySelect.appendChild(option);
        }

        // Handle category change
        categorySelect.addEventListener("change", function () {
            const selectedCategory = categorySelect.value;
            subcategorySelect.innerHTML =
                '<option value="">Select Subcategory</option>';

            if (selectedCategory) {
                categories[selectedCategory].forEach(function (subcategory) {
                    const option = document.createElement("option");
                    option.value = subcategory;
                    option.textContent = subcategory;
                    subcategorySelect.appendChild(option);
                });
            }
        });

        // Handle subcategory change
        subcategorySelect.addEventListener("change", function () {
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

    document
        .getElementById("add-product-type")
        .addEventListener("click", function () {
            if (fieldsetCount <= 3) {
                createFieldset();
            } else {
                alert("You can only add up to 3 product types.");
            }
        });

    // Fetch categories and create the initial fieldset
    fetchCategories();
});
