//
//  WishItem.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 27/10/2025.
//


import Foundation

// MARK: - Wishlist Item Model
/// Represents a wishlist item stored on the backend
struct WishItem: Codable, Identifiable {
    var id = UUID()              // Local unique identifier for SwiftUI views
    var wishItemID: String       // Backend ID of the wishlist entry
    var productID: String
    var userID: String           
    
    enum CodingKeys: String, CodingKey {
        case wishItemID = "_id"  // Map backend "_id" to wishItemID
        case productID
        case userID
    }
}

