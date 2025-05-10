import Fluent
import Vapor

final class User: Model, Authenticatable, @unchecked Sendable {
    static let schema = "users"

    struct FieldKeys {
        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
    }
    
    @ID()
    var id: UUID?

    @Field(key: FieldKeys.email)
    var email: String

    @Field(key: FieldKeys.password)
    var password: String

    init() {}

    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
