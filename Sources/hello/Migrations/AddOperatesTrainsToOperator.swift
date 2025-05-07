import Fluent

struct AddOperatesTrainsToOperator: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("operators")
            .field("operates_trains", .bool, .required, .sql(.default(true)))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("operators").delete()
    }
}
