import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';



const firebaseConfig = {
    apiKey: "AIzaSyDA9a4o0NvjPOWta_57uXBXoooVv64_TW8",
    authDomain: "ditgroup-29bfb.firebaseapp.com",
    projectId: "ditgroup-29bfb",
    storageBucket: "ditgroup-29bfb.appspot.com",
    messagingSenderId: "895206997397",
    appId: "1:895206997397:web:fe63342683db55a8398a9c",
    measurementId: "G-EFM641GYFE"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Get the table body element
const userTableBody = document.getElementById("userTableBody");

// Function to fetch users from Firestore
async function fetchUsers() {
    try {
        console.log("Fetching users from Firestore...");

        const querySnapshot = await getDocs(collection(db, "users"));
        userTableBody.innerHTML = ""; // Clear existing data

        // Log the number of documents retrieved
        console.log(`Number of users retrieved: ${querySnapshot.size}`);

        if (querySnapshot.empty) {
            console.log("No users found in the Firestore collection.");
            userTableBody.innerHTML = "<tr><td colspan='4'>No users found.</td></tr>"; // Show a message when no users are found
            return;
        }

        querySnapshot.forEach((doc) => {
            const userData = doc.data();
            const userId = doc.id;
            const firstName = userData.firstName || "N/A"; // Default to "N/A" if not present
            const surname = userData.surname || "N/A"; // Default to "N/A" if not present
            const email = userData.email || "N/A"; // Default to "N/A" if not present

            console.log(`User ID: ${userId}, Name: ${firstName} ${surname}, Email: ${email}`);

            const row = document.createElement("tr");
            row.innerHTML = `
                <td>${userId}</td>
                <td>${firstName} ${surname}</td>
                <td>${email}</td>
                <td><button onclick="openModal('${userId}', '${firstName}', '${surname}', '${email}')">View</button></td>
            `;
            userTableBody.appendChild(row);
        });
    } catch (error) {
        console.error("Error fetching users: ", error);
    }
}

// Function to open the modal
function openModal(userId, firstName, surname, email) {
    document.getElementById("userModal").style.display = "flex";
    document.getElementById("modalUserId").textContent = userId;
    document.getElementById("modalFirstName").textContent = firstName;
    document.getElementById("modalSurname").textContent = surname;
    document.getElementById("modalEmail").textContent = email;
}

// Function to close the modal
function closeModal() {
    document.getElementById("userModal").style.display = "none";
}

// Call fetchUsers on page load
document.addEventListener('DOMContentLoaded', function() {
    fetchUsers();
});

    