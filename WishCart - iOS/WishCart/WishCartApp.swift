//
//  WishCartApp.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import SwiftUI

@main
struct WishCartApp: App {
    // Dummy User as per Case Study
    @StateObject var session = SessionManager(userID: "user123")
    var body: some Scene {
        WindowGroup {
            ProductListView()
                .environmentObject(session)
        }
    }
}
