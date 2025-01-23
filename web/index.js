// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDYS61fOQ7BdwZTUk2uo4nlE70C41cjbqI",
  authDomain: "coinkids-75fcd.firebaseapp.com",
  projectId: "coinkids-75fcd",
  storageBucket: "coinkids-75fcd.firebasestorage.app",
  messagingSenderId: "557180709877",
  appId: "1:557180709877:web:cc565e1c798c5ac52f0ebc",
  measurementId: "G-V8QHW8VY1L"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);