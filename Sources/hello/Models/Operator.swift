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
    
    init() {}
    
    init(id: UUID? = nil, name: String, logo: URL, website: URL, ridden: Bool) {
        self.id = id
        self.name = name
        self.logo = logo
        self.website = website
        self.ridden = ridden
    }
}
