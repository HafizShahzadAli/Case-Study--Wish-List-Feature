//
//  ProductController.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 25/10/2025.
//

import Foundation
import Vapor
import Meow

/// Controller to handle product-related API routes
struct ProductController: RouteCollection {
    
    /// Registers routes under `/api`
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let routeProduct = routes.grouped("api")
        routeProduct.get("Products", use: getProducts) // GET /api/Products
    }
    
    /// Fetch all products from local JSON file
    /// - Returns: Array of `Product` objects
    func getProducts(req: Request) async throws -> [Product] {
        // Path to Products.json in Resources folder
        let directory = req.application.directory.resourcesDirectory + "Data/Products.json"
        
        // Load JSON data from file
        let data = try Data(contentsOf: URL(fileURLWithPath: directory))
        
        // Decode JSON into Product array
        return try JSONDecoder().decode([Product].self, from: data)
    }
}
