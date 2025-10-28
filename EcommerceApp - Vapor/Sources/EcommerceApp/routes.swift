
import Vapor

/// Registers all API route collections for the application
func routes(_ app: Application) throws {
    // Register product-related routes under /api/Products
    try app.register(collection: ProductController())
    
    // Register wishlist-related routes under /api/wishlist
    try app.register(collection: WishlistController())
}
