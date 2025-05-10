import Vapor

struct UserModelCredentialsAuthenticator: AsyncCredentialsAuthenticator {
    
    struct Input: Content {
        var email: String
        var password: String
    }

    typealias Credentials = Input

    func authenticate(credentials: Credentials, for req: Request) async throws {
        guard let user = try await User.query(on: req.db)
            .filter(\.$email, .equal, credentials.email)
            .first()
        else {
            print("User not found: \(credentials.email)")
            throw Abort(.unauthorized)
        }
        
        guard try Bcrypt.verify(credentials.password, created: user.password) else {
            print("Password verification failed for user: \(user.email)")
            throw Abort(.unauthorized)
        }

        print("User authenticated: \(user.email)")
        req.auth.login(user)
    }
    
}