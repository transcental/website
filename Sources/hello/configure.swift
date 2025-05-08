import Fluent
import FluentPostgresDriver
import Leaf
import Vapor


// configures your application
public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.routes.caseInsensitive = true
    
    let hostname = Environment.get("DATABASE_HOST") ?? "localhost"
    let port = Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432
    let username = Environment.get("DATABASE_USERNAME") ?? "vapor_username"
    let password = Environment.get("DATABASE_PASSWORD") ?? "vapor_password"
    let databaseName = Environment.get("DATABASE_NAME") ?? "vapor_database"
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: databaseName,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )
        
    app.migrations.add(CreateOperator())
    app.migrations.add(AddOperatesTrainsToOperator())
    app.migrations.add(AddDateRiddenToOperator())
    
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
