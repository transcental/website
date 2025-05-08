import Fluent
import Vapor

struct ChallengeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let challenge = routes.grouped("challenges")
        challenge.get(use: index)
        challenge.get("uk-transport", use: ukTransport)
    }
    
    func index(req: Request) async throws -> View {
        try await req.view.render("challenges/index")
    }
    
    func ukTransport(_ req: Request) async throws -> View {
        let operators = try await Operator.query(on: req.db).filter(\.$operatesTrains == true).all()
        
        return try await req.view
            .render(
                "challenges/uk-transport",
                ["operators": operators.sorted(by: { $0.name < $1.name })]
            )
    }


}
