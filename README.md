# test_ecommerce_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Flutter E-Commerce App

## Overview

This Flutter e-commerce application is a feature-rich platform built with the _MVVM architecture_ and state management using _GetX_. It provides users with a seamless shopping experience, including user authentication, product management, cart functionality, and secure payment integration.

The app incorporates _Firebase Authentication_ and _Firestore_ for backend support, as well as _Stripe_ for secure payment processing. Advanced animations powered by _Lottie, **Animate.do, and **staggered animations_ create a visually appealing and engaging user interface.

---

## Features

### Core Features

- _User Authentication_:
  - Register, login, and logout using Firebase Authentication.
- _Product Management_:
  - View product listings with search and filter options.
  - Access detailed product information, including descriptions, images, and pricing.
- _Cart Functionality_:
  - Add, view, and update products in the cart.
- _Checkout & Payments_:
  - Complete purchases securely using Stripe integration.
- _Order History_:
  - View past transactions and purchase details.

### UI/UX Enhancements

- _Animations_:
  - _Lottie_ animations for dynamic visual effects.
  - _Animate.do_ for interactive elements like buttons and icons.
  - _Staggered animations_ for smooth transitions and product grid layouts.

---

## Project Architecture

This app is developed using the _MVVM (Model-View-ViewModel)_ architecture, ensuring a clean separation of concerns and maintainable code.

### Key Layers:

1. _Model_:
   - Represents app data, such as user profiles, products, and cart items.
2. _View_:
   - Displays the UI and captures user interactions.
3. _ViewModel_:
   - Acts as a bridge between the Model and View, handling data fetching and state management using _GetX_.

---

## Setup Instructions

Follow these steps to set up and run the project:

1. _Clone the Repository_:
   ```bash
   git clone https://github.com/jasnimk/test_app
   cd test_ecommerce_app
   ```
