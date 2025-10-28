//
//  Vapor+Meow.swift
//  EcommerceApp
//
//  Created by Hafiz Shahzad on 27/10/2025.
//


import Vapor
import MongoKitten
import Meow

// MARK: - Request Extensions for MongoDB

extension Request {
    /// Access the MongoDatabase for this request, with logging metadata
    public var mongoDB: MongoDatabase {
        return application.mongoDB.adoptingLogMetadata([
            "request-id": .string(id)
        ])
    }
    
    /// Access Meow database for this request
    public var meow: MeowDatabase {
        MeowDatabase(mongoDB)
    }
}

// MARK: - Application Storage Key for MongoDB
private struct MongoDBStorageKey: StorageKey {
    typealias Value = MongoDatabase
}

// MARK: - Application Extensions for MongoDB & Meow
extension Application {
    
    /// Access the shared MongoDatabase instance
    public var mongoDB: MongoDatabase {
        get { storage[MongoDBStorageKey.self]! }
        set { storage[MongoDBStorageKey.self] = newValue }
    }
    
    /// Initialize MongoDB with a connection string
    /// - Parameter connectionString: MongoDB connection URL
    public func initializeMongoDB(connectionString: String) throws {
        self.mongoDB = try MongoDatabase.lazyConnect(to: connectionString)
    }
    
    /// Access Meow database instance for the application
    public var meow: MeowDatabase {
        MeowDatabase(mongoDB)
    }
}
