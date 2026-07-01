import Foundation

struct Restaurant: Codable, Identifiable {
    let id: Int
    let name: String
    let location: String
    let openTime: String?
    let closeTime: String?
    let photos: [RestaurantPhoto]?
    let menu: [MenuItem]?
    
    var isAlwaysOpen: Bool {
        openTime == "00:00" && closeTime == "00:00"
    }
}

struct RestaurantPhoto: Codable, Identifiable {
    let id: Int
    let restaurantId: Int
    let photoUrl: String
}

struct MenuItem: Codable, Identifiable {
    let id: Int
    let restaurantId: Int
    let name: String
    let description: String?
    let category: String
    let price: Double
    let photoUrl: String?
}
