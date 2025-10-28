//
//  WishItemDTO.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 25/10/2025.
//

import Foundation
import Vapor
import Meow

// MARK: - DTOs for Wishlist API

/// Data transfer object for creating a wishlist item
struct CreateWishItemDTO: Content {
    let productID: String
    let userID: String
    
    init(productID: String, userID: String) {
        self.productID = productID
        self.userID = userID
    }
}

/// Data transfer object for deleting a wishlist item
struct DeleteWishItemDTO: Content {
    let productID: String
    let userID: String     
    
    init(productID: String, userID: String) {
        self.productID = productID
        self.userID = userID
    }
}
