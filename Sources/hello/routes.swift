import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index")
    }

    try app.register(collection: ChallengeController())
    try app.register(collection: AdminController())
}
