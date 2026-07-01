import SwiftUI

struct RestaurantListView: View {
    @StateObject private var vm = RestaurantViewModel()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Group {
                if vm.isLoading && vm.restaurants.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        Text("Discovering spots...")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.secondary)
                    }
                } else if let error = vm.errorMessage {
                    VStack(spacing: 16) {
                        Text("Info")
                            .font(.system(size: 18, weight: .medium, design: .serif))
                        Text(LocalizedStringKey(error))
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            Task { await vm.fetchRestaurants() }
                        }) {
                            Text("RETRY")
                                .font(.system(size: 12, weight: .semibold))
                                .tracking(1.5)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(vm.filteredRestaurants) { restaurant in
                                NavigationLink(destination: RestaurantDetailView(restaurantId: restaurant.id)) {
                                    VStack(alignment: .leading, spacing: 14) {
                                        if let firstPhoto = restaurant.photos?.first?.photoUrl, let url = URL(string: firstPhoto) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Rectangle().fill(Color(white: 0.97))
                                            }
                                            .frame(height: 180)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(restaurant.name)
                                                .font(.system(size: 20, weight: .light, design: .serif))
                                                .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                            
                                            Text(restaurant.location.uppercased())
                                                .font(.system(size: 10, weight: .medium))
                                                .foregroundColor(.secondary)
                                                .tracking(1.5)
                                            
                                            HStack(spacing: 4) {
                                                Image(systemName: "clock")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                                
                                                if restaurant.isAlwaysOpen {
                                                    Text("OPEN 24/7")
                                                        .font(.system(size: 11, weight: .light))
                                                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                                                } else {
                                                    Text("\(restaurant.openTime ?? "") - \(restaurant.closeTime ?? "")")
                                                        .font(.system(size: 11, weight: .light))
                                                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                                                }
                                            }
                                            .padding(.top, 2)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 16)
                                    }
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(white: 0.91), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(FlatButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .refreshable {
                        await vm.fetchRestaurants()
                    }
                }
            }
        }
        .navigationTitle("Discover")
        .searchable(text: $vm.searchText, prompt: "Search restaurants or locations...")
        .task {
            await vm.fetchRestaurants()
        }
    }
}

struct FlatButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.99 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
