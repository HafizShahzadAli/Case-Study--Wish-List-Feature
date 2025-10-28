//
//  ProductMetaDataView.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 27/10/2025.
//

import SwiftUI

/// Displays the product's brand, name, price, and a "NEW" badge
struct ProductMetaDataView: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // Product brand in uppercase
            Text(product.brand.uppercased())
                .font(.system(size: 16, weight: .semibold))
            
            
            Text(product.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .lineLimit(2)
                .truncationMode(.tail)
            
            // Product price with currency formatting
            Text("\(product.price.formatted()) AED")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
            
            // "NEW" badge for highlighting new arrivals
            Text("NEW")
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(4)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.leading, 5)
    }
}

#Preview {
    // ProductMetaDataView(product: Product(...))
}
