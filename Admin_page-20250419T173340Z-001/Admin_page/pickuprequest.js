function viewDetails(userName, bagId, address, date, time, instructions) {
    // Fill in the details table with the provided information
    document.getElementById("customer-name").innerText = userName;
    document.getElementById("detail-bag-id").innerText = bagId;
    document.getElementById("detail-address").innerText = address;
    document.getElementById("detail-date").innerText = date;
    document.getElementById("detail-time").innerText = time;
    document.getElementById("detail-instructions").innerText = instructions;

    // Show the pickup details section
    document.getElementById("pickup-details").style.display = "block";
}
