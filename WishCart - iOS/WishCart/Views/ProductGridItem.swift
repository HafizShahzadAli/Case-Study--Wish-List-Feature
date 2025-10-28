//
//  ProductGridItem.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import Foundation
import SwiftUI

/// Represents a single product item in the grid with image, metadata, and favorite toggle
struct ProductGridItem: View {
    @Binding var product: Product
    @EnvironmentObject var session: SessionManager
    var objProductViewModel: ProductsViewModel        
    
    // Adaptive height for grid item
    let height = UIScreen.main.bounds.height / 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            ZStack(alignment: .topTrailing) {
                // Product image with caching and placeholder
                ProductImageView(imageUrl: product.imageUrl)
                
                // Favorite toggle button
                Button {
                    objProductViewModel.toggleFavourite(for: product, userID: session.userID)
                } label: {
                    Image(systemName: product.isFavourte ? "heart.fill" : "heart")
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding(10)
            }
            .frame(height: height)
            
            // Product details: brand, name, price, badge
            ProductMetaDataView(product: product)
        }
    }
}

// SwiftUI preview
#Preview {
   // ProductGridItem(product: Product.sample )
}
