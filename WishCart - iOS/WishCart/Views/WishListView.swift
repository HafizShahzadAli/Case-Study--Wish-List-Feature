//
//  WishListView.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 27/10/2025.
//

import SwiftUI

/// Displays the user's wishlist with product images and metadata
struct WishListView: View {
    @ObservedObject var objProductsVM: ProductsViewModel
    @EnvironmentObject var session: SessionManager
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            // Main wishlist list
            List {
                ForEach(objProductsVM.wishListProducts) { item in
                    HStack {
                        // Product image
                        ProductImageView(imageUrl: item.imageUrl)
                            .frame(width: screenSize.width / 3)
                        
                        // Product details
                        ProductMetaDataView(product: item)
                    }
                    .frame(height: screenSize.height / 4, alignment: .top)
                }
                .onDelete { index in
                    
                    let itemsToDelete = index.map { objProductsVM.wishListProducts[$0] }
                    objProductsVM.wishListProducts.remove(atOffsets: index)
                    
                    // Async deletion from backend for multi-device consistency
                    Task {
                        for item in itemsToDelete {
                            await objProductsVM.removeWishItem(
                                productID: item.productID,
                                userID: session.userID
                            )
                            
                            await objProductsVM.loadData(userID: session.userID)
                        }
                    }
                }
                
                if objProductsVM.wishListProducts.isEmpty {
                    Text("Your wishlist is empty. Please select some items to add to your wishlist.")
                        .foregroundColor(.secondary)
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            
            // Overlay shown during loading or error state
                LoadingOverlayView(
                    isLoading: $objProductsVM.isLoading,
                    errorMessage: $objProductsVM.errorMessage
                )
        }
        // Show wishlist count in navigation title
        .navigationTitle("WishList(\(objProductsVM.wishListProducts.count))")
        .task {
            // Fetch latest wishlist for current user
            await objProductsVM.loadData(userID: session.userID)
        }
    }
}

// Preview for SwiftUI canvas
#Preview {
    // WishListView(objProductsVM: ProductsViewModel())
}
