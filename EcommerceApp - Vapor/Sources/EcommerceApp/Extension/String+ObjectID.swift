//
//  String+ObjectID.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 27/10/2025.
//

import Foundation
import Meow
import Vapor

/// Utility extensions on String for MongoDB ObjectId handling
extension String {
    
    /// Checks if the string is a valid MongoDB ObjectId
    var isValidObjectID: Bool {
        ObjectId(self) != nil
    }
    
    /// Converts the string to ObjectId. Returns nil if invalid.
    var toObjectId: ObjectId? {
        ObjectId(self)
    }
    
    /// Converts the string to ObjectId or throws a bad request error if invalid
    func toObjectIdOrThrow() throws -> ObjectId {
        guard let objID = ObjectId(self) else {
            throw Abort(.badRequest, reason: "Invalid ObjectId string: \(self)")
        }
        return objID
    }
}
