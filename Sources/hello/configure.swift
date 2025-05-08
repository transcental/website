import Fluent
import FluentPostgresDriver
import Leaf
import Vapor


// configures your application
public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.routes.caseInsensitive = true
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? .ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
                password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
                database: Environment.get("DATABASE_NAME") ?? "vapor_database",
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )
        
    app.migrations.add(CreateOperator())
    app.migrations.add(AddOperatesTrainsToOperator())
    
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
