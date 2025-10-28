//
//  ContentView.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import SwiftUI

/// Displays a grid of products with navigation to wishlist
struct ProductListView: View {
    
    // MARK: - Properties
    @ObservedObject var objProductVM = ProductsViewModel()
    @EnvironmentObject var session: SessionManager
    @State private var gotoWishList: Bool = false
    
    // Grid layout configuration
    let gridColumns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Product grid scroll view
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 16) {
                        ForEach($objProductVM.products) { $product in
                            ProductGridItem(product: $product,
                                            objProductViewModel: objProductVM)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .navigationTitle("New In")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Wishlist button in navigation bar
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            gotoWishList = true
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 35, height: 35)
                                    .overlay {
                                        Image(systemName: "heart")
                                    }
                            }
                        }
                    }
                }
                // Navigate to wishlist when button tapped
                .navigationDestination(isPresented: $gotoWishList) {
                    WishListView(objProductsVM: objProductVM)
                }
                
                // Loader during data fetching
              
                    LoadingOverlayView(isLoading: $objProductVM.isLoading,
                                       errorMessage: $objProductVM.errorMessage)
                
            }
        }
        .task {
            await objProductVM.loadData(userID: session.userID)
        }
    }
}

#Preview {
    ProductListView()
}
