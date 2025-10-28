//
//  ProductsViewModel.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import Foundation
import Foundation

/// ViewModel to manage products and wishlist state
@MainActor
class ProductsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products = [Product]()             // All products
    @Published var wishListProducts: [Product] = []   // Favorite products
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    private let apiService = APIService()        
    
    // MARK: - Initializer
    init() { }
    
    // MARK: - Fetch all products
    func fetchProducts() async -> [Product] {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchResults = try await apiService.fetchProducts()
            return fetchResults
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching products: \(error)")
            return []
        }
    }
    
    // MARK: - Add product to wishlist
    func addWishItem(product: Product, userID: String) async {
        do {
            
            let result = try await apiService.addFavoriteProduct(productID: product.productID, userID: userID)
            print("Added to wishlist:", result)
        } catch {
            errorMessage = error.localizedDescription
            print("Error adding wishlist item:", error)
        }
    }
    
    // MARK: - Fetch wishlist items for user
    func getAllWishProducts(userID: String) async -> [WishItem] {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchResults = try await apiService.fetchFavoriteProducts(userID: userID)
            return fetchResults
        } catch {
            errorMessage = error.localizedDescription
            print("Error fetching wishlist:", error)
            return []
        }
    }
    
    // MARK: - Remove product from wishlist
    func removeWishItem(productID: String, userID: String) async {
        do {
            try await apiService.removeFavoriteProduct(productID: productID, userID: userID)
        } catch {
            errorMessage = error.localizedDescription
            print("Error removing wishlist item:", error)
        }
    }
    
    // MARK: - Load products and wishlist concurrently
    @MainActor
    func loadData(userID: String) async {
        isLoading = true
        defer { isLoading = false }
        
        async let products = apiService.fetchProducts()
        async let wishProducts = apiService.fetchFavoriteProducts(userID: userID)

        do {
            let (allProducts, favs) = try await (products, wishProducts)
            
            // Debug prints
            print("Loaded products:", allProducts.count)
            print("Loaded wishlist:", favs.count)
            
            // Update products with favorite flag
            self.products = allProducts.map { product in
                var updatedProduct = product
                updatedProduct.isFavourte = favs.contains { $0.productID == product.productID }
                return updatedProduct
            }
            
            // Update wishlist products
            self.wishListProducts = allProducts.filter { product in
                favs.contains { $0.productID == product.productID }
            }
            
        } catch {
            errorMessage = error.localizedDescription
            print("Error loading data:", error)
        }
    }
    
    // MARK: - Toggle favorite state
    func toggleFavourite(for product: Product, userID: String) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavourte.toggle()
            Task {
                if products[index].isFavourte {
                    await addWishItem(product: products[index], userID: userID)
                }
                else {
                    await removeWishItem(productID: products[index].productID, userID: userID)
                }
            }
        }
    }
}
