//
//  SDWebImage.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import SDWebImageSwiftUI
import SwiftUI

/// Displays a product image with caching, placeholder, and subtle styling
struct ProductImageView: View {
    let imageUrl: String
    
    var body: some View {
        WebImage(url: URL(string: imageUrl)) { image in
            // Image container with background
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .overlay {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(12)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                }
        } placeholder: {
            // Placeholder while image loads or fails
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "photo")
                    .font(.system(size: 30))
                    .foregroundColor(.gray.opacity(0.6))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
        .indicator(.activity)                         // Loading spinner
        .transition(.fade(duration: 0.5))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
