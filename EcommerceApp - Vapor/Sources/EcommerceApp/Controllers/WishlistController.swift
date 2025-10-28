//
//  WishlistController.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 25/10/2025.
//

import Vapor
import Meow

/// Controller to manage wishlist-related API routes
struct WishlistController: RouteCollection {
    
    /// Register routes under `/api/wishlist`
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let rootRoute = routes.grouped("api")
        rootRoute.get("wishlist", ":userID", use: getWishlist)
        rootRoute.post("wishlist",":userID", ":productID", use: createWishlist)
        rootRoute.delete("wishlist",":userID", ":productID", use: deleteWishList)
    }
    
    /// Fetch wishlist items for a specific user
    func getWishlist(req: Request) async throws -> [WishListItem] {
        print("Get Wish List")
        guard let userID = req.parameters.get("userID") else {
            return []
        }
        
        let collection = req.meow[WishListItem.self]
        return try await collection
            .find { wish in wish.$userID == userID }
            .drain()
    }
    
    /// Add a product to the wishlist
    func createWishlist(req: Request) async throws -> WishListItem {
        guard
            let userID = req.parameters.get("userID"),
            let productID = req.parameters.get("productID")
            else {
                throw Abort(.badRequest, reason: "Missing path parameters")
            }
        
        let collection = req.meow[WishListItem.self]
        
        // Validate Product ID
        let productId = try productID.toObjectIdOrThrow()
        
        // Prevent duplicates
        let recordExists = try await collection.findOne { wish in
            wish.$productID == productId && wish.$userID == userID
        }
        if recordExists != nil {
            throw Abort(.badRequest, reason: "Record already exists")
        }
        
        // Save new wishlist item
        let wishItem = WishListItem(productID: productId, userID: userID)
        try await wishItem.save(in: req.meow)
        
        return wishItem
    }
    
    /// Remove a product from the wishlist
    func deleteWishList(req: Request) async throws -> HTTPStatus {
        guard
            let userID = req.parameters.get("userID"),
            let productID = req.parameters.get("productID")
            else {
                throw Abort(.badRequest, reason: "Missing path parameters")
            }
        
        // Validate Product ID
        let productId = try productID.toObjectIdOrThrow()
        
        // Check if record exists
        let recordExist = try await req.meow[WishListItem.self].findOne { wish in
            wish.$productID == productId && wish.$userID == userID
        }
        if recordExist == nil {
            throw Abort(.badRequest, reason: "Product does not exist")
        }
        
        // Delete the wishlist record
        try await req.meow[WishListItem.self].deleteAll { wish in
            (wish.$userID == userID && wish.$productID == productId).makeDocument()
        }
        
        return .ok
    }
}
