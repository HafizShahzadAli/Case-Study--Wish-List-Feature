import Vapor
import MongoKitten

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    guard let mongoURL = Environment.get("MONGO_URL") else {
            fatalError(" MONGO_URL not set in environment variables")
        }
    
    try app.initializeMongoDB(connectionString: mongoURL)
    // register routes
    try routes(app)
}
