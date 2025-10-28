//
//  SessionManager.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 27/10/2025.
//

import SwiftUI

/// Manages the current user session
@MainActor
class SessionManager: ObservableObject {
    @Published var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
}

