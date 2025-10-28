//
//  Product.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 25/10/2025.
//

import Foundation
import Meow
import Vapor

/// Represents a Product stored in MongoDB
/// Conforms to `Model` for Meow and `Content` for Vapor JSON encoding/decoding
struct Product: Model, Content {
    
    @Field var _id: ObjectId      // MongoDB ObjectId, primary key
    @Field var brand: String
    @Field var name: String
    @Field var price: Double
    @Field var category: String
    @Field var imageUrl: String
    @Field var addDate: String     // ISO 8601 string
    
    /// Initializes a new Product
    init(_id: ObjectId = ObjectId(), brand: String, name: String, price: Double, category: String, imageUrl: String, addDate: String) {
        self._id = _id
        self.brand = brand
        self.name = name
        self.price = price
        self.category = category
        self.imageUrl = imageUrl
        self.addDate = addDate
    }
}
