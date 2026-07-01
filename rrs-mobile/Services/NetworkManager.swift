import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let baseURL = "http://192.168.0.7:3000"
    
    private init() {}
}
