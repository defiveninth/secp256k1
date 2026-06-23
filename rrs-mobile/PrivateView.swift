import SwiftUI

struct PrivateView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Home page")
            }
            .navigationTitle("Home")
        }
    }
}

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("History")
            }
            .navigationTitle("History")
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("User Profile")
                    .font(.title)
            }
                .navigationTitle("Profile")
        }
    }
}

#Preview {
    PrivateView()
}
