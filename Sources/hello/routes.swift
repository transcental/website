import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("uuid") { req async-> String in
        let uuid = UUID()
        return uuid.uuidString
    }
    
    try app.register(collection: ChallengeController())
}
