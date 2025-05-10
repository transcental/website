import Fluent

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users").id().field("email", .string, .required).field("password", .string, .required).create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}