import Fluent

struct AddDateRiddenToOperator: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("operators")
            .field("date_ridden", .date)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("operators").deleteField("date_ridden")
    }
}
