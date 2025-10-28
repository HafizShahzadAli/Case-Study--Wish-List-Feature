//
//  WishListItem.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 25/10/2025.
//

import Foundation
import Meow
import Vapor

/// Represents a wishlist entry stored in MongoDB
/// Conforms to `Model` for Meow and `Content` for Vapor JSON encoding/decoding
struct WishListItem: Model, Content {
    
    @Field var _id: ObjectId       // MongoDB primary key
    @Field var productID: ObjectId // Linked product's ObjectId
    @Field var userID: String      // User who added the product
    
    /// Initializes a new wishlist item
    init(productID: ObjectId, userID: String) {
        self._id = ObjectId()      // Generate a new ObjectId for each entry
        self.productID = productID
        self.userID = userID
    }
}
