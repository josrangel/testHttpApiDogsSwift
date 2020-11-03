import Foundation

struct Dog: Decodable, Equatable{
    
    let id: String
    let sellerID: String
    let gender: String
    let about: String
    let birthday: Date
    let breed: String
    let breederRating: Double
    let cost: Decimal
    let created: Date
    let imageURL: URL
    let name: String
}
