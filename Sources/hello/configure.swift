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
                hostname: Environment.get("DB_HOST") ?? "localhost",
                port: Environment.get("DB_PORT").flatMap(Int.init(_:)) ?? 5432,
                username: Environment.get("DB_USER") ?? "postgres",
                password: Environment.get("DB_PASSWORD") ?? "password",
                database: Environment.get("DB_NAME") ?? "postgres",
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        ),
        as: .psql
    )
    
    app.migrations.add(CreateOperator())
    
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
