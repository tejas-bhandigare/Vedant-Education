# 📚 Vedant Education

A Flutter-based Educational E-Commerce Mobile Application developed for schools, students, and parents to simplify the ordering and management of educational resources such as books, uniforms, bags, certificates, ID cards, diaries, and other academic materials.

 🚀 Project Overview

Vedant Education digitizes the traditional educational resource procurement process by providing a centralized mobile platform for browsing products, placing orders, tracking order status, submitting feedback, and reporting defective products.

The application eliminates manual ordering through phone calls, WhatsApp messages, and spreadsheets, providing a more efficient and transparent ordering system.



 ✨ Features

 👨‍🎓 User Features

* User Registration & Login
* Browse Educational Products
* Category-Based Product Listing
* Product Details & Pricing
* Add Products to Cart
* Place Orders
* Order History Tracking
* Submit Feedback & Ratings
* Report Defective Products
* User Profile Management

 👨‍💼 Admin Features

* Admin Login
* Product Management
* Order Management
* Order Status Updates
* View Customer Feedback
* Manage Defective Product Reports
* User Information Management



 🏗️ System Architecture

```text
Flutter Mobile Application
            │
            ▼
      Supabase SDK
            │
            ▼
      Supabase Cloud
      ├── Authentication
      ├── PostgreSQL Database
      └── Storage
```

---

🛠️ Tech Stack

 Frontend

* Flutter
* Dart

 Backend Services

* Supabase

### Database

* PostgreSQL

 Authentication

* Supabase Auth

 Storage

* Supabase Storage

 State Management

* Provider

 Local Storage

* SharedPreferences

---

 📂 Project Modules

 1. Authentication Module

* User Registration
* Login
* Logout
* Session Management

 2. Product Catalogue Module

* Category Listing
* Product Browsing
* Product Details

 3. Cart Module

* Add to Cart
* Remove Items
* Quantity Management
* Total Calculation

 4. Order Management Module

* Place Order
* View Orders
* Track Order Status

 5. Feedback Module

* Ratings
* Reviews
* Customer Feedback

 6. Complaint Module

* Defective Product Reporting
* Image Upload Support

 7. Admin Module

* Manage Products
* Manage Orders
* View Complaints
* Update Order Status



🗄️ Database Design

 Profiles Table

| Field     | Type |
| --------- | ---- |
| id        | UUID |
| full_name | Text |
| email     | Text |
| phone     | Text |
| address   | Text |

 Orders Table

| Field            | Type  |
| ---------------- | ----- |
| id               | UUID  |
| user_id          | UUID  |
| total_amount     | Float |
| status           | Text  |
| customer_name    | Text  |
| customer_address | Text  |

 Order Items Table

| Field        | Type    |
| ------------ | ------- |
| id           | UUID    |
| order_id     | UUID    |
| product_name | Text    |
| price        | Float   |
| quantity     | Integer |

 Feedback Table

| Field   | Type    |
| ------- | ------- |
| id      | UUID    |
| user_id | UUID    |
| rating  | Integer |
| comment | Text    |



 🔄 Application Workflow

```text
User Registration/Login
            ↓
Browse Products
            ↓
Add Products to Cart
            ↓
Place Order
            ↓
Store Order in PostgreSQL
            ↓
Track Order Status
            ↓
Provide Feedback / Report Issues
```


 📱 Screens

* Login Screen
* Signup Screen
* Home Screen
* Category Screen
* Product Details Screen
* Cart Screen
* Order History Screen
* Profile Screen
* Feedback Screen
* Defective Product Screen
* Admin Dashboard
* Order Management Screen


 🔒 Security Features

* Supabase Authentication
* JWT-Based Session Management
* PostgreSQL Data Integrity
* Secure Cloud Storage
* Row Level Security (RLS)

 🧪 Testing

The application was tested using:

* Unit Testing
* Integration Testing
* System Testing
* Acceptance Testing
* Regression Testing

Major test scenarios include:

* User Login
* User Registration
* Cart Operations
* Order Placement
* Order Tracking
* Admin Operations
* Feedback Submission


 📈 Future Enhancements

* Razorpay Payment Gateway Integration
* Push Notifications (FCM)
* Dynamic Product Management
* Role-Based Access Control (RBAC)
* Web Admin Dashboard
* Delivery Tracking
* Multi-Language Support
* AI-Based Demand Prediction
* Analytics Dashboard
* Offline Mode with Data Synchronization



🎓 Academic Information

**Project Title:** Vedant Education

**Degree:** Master of Computer Applications (MCA)

**Institute:** Sinhgad Institute of Management and Computer Application (SIMCA), Pune

**University:** Savitribai Phule Pune University

**Academic Year:** 2025-2026


📜 License

This project was developed for academic and educational purposes as part of the MCA curriculum.
