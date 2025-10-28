//
//  LoadingOverlayView.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 27/10/2025.
//
import SwiftUI
/// Reusable overlay for showing a loader and optional error alert
struct LoadingOverlayView: View {
    
    @Binding var isLoading: Bool      // Show/hide loader
    @Binding var errorMessage: String? // Optional alert message
    
    @State private var showAlert = false // Controls alert presentation safely
    
    var body: some View {
        ZStack {
            if isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                
                ProgressView("Loading...")
                    .padding(20)
                    .background(.regularMaterial)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isLoading)
        .onChange(of: errorMessage) {
            if errorMessage != nil { showAlert = true }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
}

#Preview {
    LoadingOverlayView(
        isLoading: .constant(true),
        errorMessage: .constant("Something went wrong")
    )
}

