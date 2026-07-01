import Foundation
import Combine

@MainActor
class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurant: Restaurant? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    
    var filteredRestaurants: [Restaurant] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter { restaurant in
                restaurant.name.localizedStandardContains(searchText)
                || restaurant.location.localizedStandardContains(searchText)
            }
        }
    }
    
    private let baseURL = NetworkManager.shared.baseURL
    
    func fetchRestaurants() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: "\(baseURL)/restaurants") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
            isLoading = false
        } catch {
            isLoading = false
            self.errorMessage = NSLocalizedString("Failed to load restaurants. Did you initialize the mock data?", comment: "")
        }
    }

    func fetchRestaurantDetails(id: Int) async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: "\(baseURL)/restaurants/\(id)") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.selectedRestaurant = try JSONDecoder().decode(Restaurant.self, from: data)
            isLoading = false
        } catch {
            isLoading = false
            self.errorMessage = NSLocalizedString("Failed to load restaurant menu profile.", comment: "")
        }
    }
}
