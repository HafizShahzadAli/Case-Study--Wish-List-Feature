# WishCart Case Study

## Overview
**WishCart** is an iOS application built with SwiftUI that allows users to browse products and manage their wishlists.  
The backend is powered by **Vapor (`EcommerceApp`)**, with **MongoDB** as the database and **Meow** as the ORM.  

---

## Folder Structure

```
WishCartCaseStudy/
│
├── README.md
├── WishCart/             # SwiftUI front-end
│   └── WishCart.xcodeproj
├── EcommerceApp/         # Vapor back-end
│   └── Package.swift
└── Docker/               # Docker commands for MongoDB and Mongo Express
```

---

## 1. Docker Setup (MongoDB + Mongo Express)

Because we want to see MongoDB and MongoDB express on same network to view data
### **Step 1: Create Docker Network**

```bash
docker network create vapor-network
```

---

### **Step 2: Run MongoDB**

```bash
docker run -d \
  --name mongo_db \
  --network vapor-network \
  -p 32768:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=qwerty \
mongo:latest
```

**Verify MongoDB is running:**

```bash
docker ps
```

---

### **Step 3: Run Mongo Express (Web UI for MongoDB)**

```bash
docker run -d \
  --name mongo_express \
  --network vapor-network \
  -p 8081:8081 \
  -e ME_CONFIG_MONGODB_SERVER=mongo_db \
  -e ME_CONFIG_MONGODB_PORT=27017 \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=qwerty \
mongo-express:latest
```

- Mongo Express Web UI is accessible at [http://localhost:8081](http://localhost:8081).  

---

## 2. Vapor Backend Setup (`EcommerceApp`)

1. Build Docker image for backend:

```bash
cd EcommerceApp
docker build -t ecommerceapp .
```

2. Run backend container:

```bash
docker run -d \
  --name ecommerceapp \
  --network vapor-network \
  -p 8080:8080 \
  -e MONGO_URL="mongodb://admin:qwerty@mongo_db:27017/wishcart?authSource=admin" \
  ecommerceapp
```

3. Verify backend is running:

```bash
docker ps
```

- API is available at [http://localhost:8080](http://localhost:8080).  

---

## 3. API Routes Overview

### **Product API (`ProductController`)**

| Method | Route        | Description                     |
|--------|--------------|---------------------------------|
| GET    | /api/Products | Fetch all products from JSON file |

- Products are loaded from `Resources/Data/Products.json`.

---

### **Wishlist API (`WishlistController`)**

| Method | Route                        | Description                         |
|--------|------------------------------|-------------------------------------|
| GET    | /api/wishlist/:userID        | Fetch wishlist items for a user     |
| POST   | /api/wishlist/:userID/:productID | Add a product to the wishlist     |
| DELETE | /api/wishlist/:userID/:productID | Remove a product from the wishlist |

**Notes:**
- Duplicate wishlist items are prevented.  
- Deletion checks if the item exists before removing.  

---

## 4. iOS App Setup (`WishCart`)

1. Open Xcode project:

```
WishCart/WishCart.xcodeproj
```

2. Set the API base URL:

```swift
let baseURL = "http://localhost:8080/api"
```

3. Build and run on simulator or device.

**UX Note:**  
- Swipe-to-delete products from the wishlist shows a loader while communicating with the backend.  

---

## 5. Database Choice

**Database:** MongoDB  
**ORM:** Meow  

**Justification:**
- Document-based schema fits products and wishlists naturally.  
- Meow integrates seamlessly with Vapor async API.  
- Flexible schema allows easy addition of new features.  

---

## 6. Assumptions

- Each user has a unique `userID`.  
- Products are pre-populated from `Products.json`.  
- No authentication implemented yet.  
- Backend and database run in separate Docker containers connected via the same network.  

---

## 7. Learning Process & Challenges

- Learned **Vapor** and async routing using official docs.  
- Integrated **MongoDB** using **Meow** ORM.  
- Managed **async data fetching** in SwiftUI for real-time wishlist updates.  
- Challenges: handling duplicates, validating product IDs, keeping UI in sync with backend.  

---

## 8. Future Improvements

- Add user authentication and accounts.  
- Paging or cursor for large number of products.  
- Product search and filtering.   
- More detailed error handling and UX improvements.  

---

## 9. Demo Video for How to Set Up and Working

https://youtu.be/tZaFUJPW3Y8

