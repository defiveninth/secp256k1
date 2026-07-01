import Foundation
typealias Cdbl = Encodable & Decodable
struct User: Cdbl, Identifiable {
    let id: Int
    let email: String
    let fullname: String?
}
