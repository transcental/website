import Fluent
import Foundation
import Vapor

final class Operator: Model, Content, @unchecked Sendable {
    static let schema = "operators"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "logo")
    var logo: URL
    
    @Field(key: "website")
    var website: URL
    
    @Field(key: "ridden")
    var ridden: Bool
    
    @Field(key: "operates_trains")
    var operatesTrains: Bool
    
    @OptionalField(key: "date_ridden")
    var dateRidden: Date?
    
    init() {}
    
    init(id: UUID? = nil, name: String, logo: URL, website: URL, ridden: Bool, operatesTrains: Bool = true, dateRidden: Date? = nil) {
        self.id = id
        self.name = name
        self.logo = logo
        self.website = website
        self.ridden = ridden
        self.operatesTrains = operatesTrains
        self.dateRidden = dateRidden
    }
}
