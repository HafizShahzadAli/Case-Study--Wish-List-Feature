//
//  Date+Bool.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 26/10/2025.
//

import Foundation
// For New Arrival items if date if one week old - if not handled from backend
extension Date {
    
    var isOneWeekAgo: Bool {
        guard let days = Calendar.current.dateComponents([.day], from: self, to: Date.now).day else
        {
           return true
        }
        print("days :: \(days)")
        return  days > 7
    }
}
