import Fluent

struct CreateOperator: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("operators")
            .id()
            .field("name", .string, .required)
            .field("logo", .string, .required)
            .field("website", .string, .required)
            .field("ridden", .bool, .required)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("operators").delete()
    }
}
