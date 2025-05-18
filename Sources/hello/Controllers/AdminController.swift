import Fluent
import Vapor

struct AdminController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let admin = routes.grouped("admin")
        admin.get("login", use: loginPage)
        admin.post("login", use: login)
        
        let protected = admin.grouped(SessionAuthMiddleware())
        protected.get(use: index)
        
        protected.get("challenges/uk-operators", use: ukOperators)
        protected.post("api/challenges/add-operator", use: addOperator)
    }
    
    func loginPage(_ req: Request) async throws -> View {
        try await req.view.render("admin/login")
    }
    
    func login(_ req: Request) async throws -> Response {
        struct LoginData: Content {
            let email: String
            let password: String
        }
        
        let loginData = try req.content.decode(LoginData.self)
        let credentials = UserModelCredentialsAuthenticator.Input(
            email: loginData.email,
            password: loginData.password
        )
        
        let authenticator = UserModelCredentialsAuthenticator()
        try await authenticator.authenticate(credentials: credentials, for: req)
        
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "Authentication failed")
        }
        
        req.session.data["userId"] = user.id?.uuidString
        
        print("User logged in: \(user.email)")
        return req.redirect(to: "/admin")
    }
    
    func index(req: Request) async throws -> View {
        let user = try req.auth.require(User.self)
        print("User authenticated: \(user.email)")
        return try await req.view.render("admin/index")
    }
    
    func ukOperators(_ req: Request) async throws -> View {
        let operators = try await Operator.query(on: req.db).filter(\.$operatesTrains == true).all()
        
        return try await req.view
            .render(
                "admin/challenges/uk-operators",
                ["operators": operators.sorted(by: { $0.name < $1.name })]
            )
    }
    
    func addOperator(_ req: Request) async throws -> Response {
        struct OperatorData: Content {
            let name: String
            let logo: URL
            let website: URL
            let ridden: Bool
            let dateRidden: Date?
            let operatesTrains: Bool
        }
        
        let operatorData = try req.content.decode(OperatorData.self)
        
        let newOperator = Operator(
            name: operatorData.name,
            logo: operatorData.logo,
            website: operatorData.website,
            ridden: operatorData.ridden,
            operatesTrains: operatorData.operatesTrains,
            dateRidden: operatorData.dateRidden
        )
        
        try await newOperator.save(on: req.db)
        
        return req.redirect(to: "/challenges/uk-operators")
    }
}

struct SessionAuthMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let userId = req.session.data["userId"],
              let user = try await User.find(UUID(uuidString: userId), on: req.db) else {
            throw Abort(.unauthorized, reason: "User not authenticated")
        }
        
        req.auth.login(user)
        
        return try await next.respond(to: req)
    }
}
