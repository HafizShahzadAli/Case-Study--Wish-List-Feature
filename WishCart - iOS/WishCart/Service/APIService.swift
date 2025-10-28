//
//  APIService.swift
//  WishCart
//
//  Created by Hafiz Shahzad on 27/10/2025.
//

import Foundation

// MARK: - API Method Types
enum APIMethod: String {
    case GET, POST, PUT, DELETE
}

// MARK: - API Errors
enum APIError: Error {
    case invalidURL
    case requestFailed(Int)
    case unknown(Error)
    case decodingError
    case noInternetConnection
    case hostNotFound
}

// MARK: - For Empty Body Response
struct EmptyResponse: Decodable {}

// Provide human-readable error descriptions
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let statusCode):
            return "Request failed with status code \(statusCode)."
        case .decodingError:
            return "Failed to decode the response."
        case .noInternetConnection:
            return "No internet connection. Please check your network."
        case .hostNotFound:
            return "Failed to reach the server. Ensure the server is running and your network is connected."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func request<T: Decodable>(
        endPoint: String,
        method: String,
        body: Encodable?
    ) async throws -> T?
}

// MARK: - API Service Implementation
final class APIService: APIServiceProtocol {
    
    private let baseURL = "http://127.0.0.1:8080" // Local backend base URL
    
    /// Generic async request method for all API calls
    func request<T: Decodable>(
        endPoint: String,
        method: String,
        body: (any Encodable)?
    ) async throws -> T {
        
        // Validate URL
        guard let url = URL(string: baseURL + endPoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode body if provided
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(-1)
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.requestFailed(httpResponse.statusCode)
            }
            
            do {
               
                // Decode JSON response into expected model
                return try JSONDecoder().decode(T.self, from: data)
                
            } catch {
                print("Decoding Error:", error)
                throw APIError.decodingError
            }
        }
        catch let urlError as URLError where urlError.code == .cannotFindHost || urlError.code == .cannotConnectToHost {
            throw APIError.hostNotFound
        }
        catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw APIError.noInternetConnection
        }
        catch {
            print("Unknown Error:", error)
            throw APIError.unknown(error)
        }
    }
}

// MARK: - Extending API Service Implementation for Void return function
extension APIService {
    
    /// Generic async request method for all API calls
    func request(
        endPoint: String,
        method: String,
        body: (any Encodable)?
    ) async throws {
        
        // Validate URL
        guard let url = URL(string: baseURL + endPoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode body if provided
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.requestFailed(-1)
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw APIError.requestFailed(httpResponse.statusCode)
            }
        }
        catch let urlError as URLError where urlError.code == .cannotFindHost || urlError.code == .cannotConnectToHost {
            throw APIError.hostNotFound
        }
        catch let urlError as URLError where urlError.code == .notConnectedToInternet {
            throw APIError.noInternetConnection
        }
        catch {
            print("Unknown Error:", error)
            throw APIError.unknown(error)
        }
    }
}

// MARK: - Specific API Methods
extension APIService {
    
    /// Fetch all products
    func fetchProducts() async throws -> [Product] {
        try await request(endPoint: "/api/Products", method: APIMethod.GET.rawValue, body: nil)
    }
    
    /// Add a product to favorites (wishlist)
    func addFavoriteProduct(productID: String, userID:String) async throws -> WishItem {
        try await request(endPoint: "/api/wishlist/\(userID)/\(productID)", method: APIMethod.POST.rawValue, body: nil)
    }
    
    /// Fetch favorite products for a specific user
    func fetchFavoriteProducts(userID: String) async throws -> [WishItem] {
        try await request(endPoint: "/api/wishlist/\(userID)", method: APIMethod.GET.rawValue, body: nil)
    }
    
    /// Remove a product from favorites
    func removeFavoriteProduct(productID: String, userID:String) async throws  {
        try await request(endPoint: "/api/wishlist/\(userID)/\(productID)", method: APIMethod.DELETE.rawValue, body: nil)
    }
}
