//
//  Product.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import Foundation

/// Represents a product in the catalog
struct Product: Codable, Identifiable {
    var id = UUID()              // Local ID for SwiftUI views
    var productID: String        // Backend product ID
    var category: String
    var brand: String
    var imageUrl: String
    var addDate: String
    var price: Double
    var name: String
    var isFavourte: Bool = false // Track if product is marked as favorite
    
    // Map backend keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case productID = "_id"
        case category
        case brand
        case imageUrl
        case addDate
        case price
        case name
    }
    
    // Sample product for previews or testing
    static let sample = Product(
        productID: "1234",
        category: "shoes",
        brand: "Prada",
        imageUrl: "https://static.vecteezy.com/system/resources/previews/027/252/617/non_2x/modern-sport-shoes-free-png.png",
        addDate: "2025-10-22T10:15:30Z",
        price: 2860,
        name: "Triple S Paint Sneaker"
    )
}
