import SwiftUI

struct MainTabView: View {
    @Binding var isAuthenticated: Bool
    
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    @State private var showLanguagePicker = false
    
    @State private var userFullName: String = UserDefaults.standard.string(forKey: "userFullName") ?? "Guest User"
    @State private var userEmail: String = UserDefaults.standard.string(forKey: "userEmail") ?? "guest@example.com"
    
    private var currentLanguageName: String {
        switch appLanguage {
        case "ru": return "Русский"
        case "kk": return "Қазақша"
        default: return "English"
        }
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                RestaurantListView()
            }
            .tabItem {
                Label("Explore", systemImage: "fork.knife")
            }

            NavigationStack {
                ReservationHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
            
            NavigationStack {
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 36) {
                            Spacer(minLength: 10)
                            
                            VStack(spacing: 16) {
                                let initials = userFullName
                                    .components(separatedBy: " ")
                                    .reduce("") { $0 + ($1.first.map(String.init) ?? "") }
                                    .prefix(2)
                                
                                if initials.isEmpty {
                                    Text("GU")
                                        .font(.system(size: 28, weight: .light, design: .serif))
                                        .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                        .frame(width: 80, height: 80)
                                        .background(Color(white: 0.97))
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color(white: 0.9), lineWidth: 1)
                                        )
                                } else {
                                    Text(initials)
                                        .font(.system(size: 28, weight: .light, design: .serif))
                                        .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                        .frame(width: 80, height: 80)
                                        .background(Color(white: 0.97))
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(Color(white: 0.9), lineWidth: 1)
                                        )
                                }
                                
                                VStack(spacing: 6) {
                                    Text(userFullName)
                                        .font(.system(size: 24, weight: .light, design: .serif))
                                        .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                    
                                    Text(userEmail.uppercased())
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .tracking(1.5)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("ACCOUNT PREFERENCES")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.5)
                                
                                VStack(spacing: 0) {
                                    ProfileRow(title: "Profile Settings", value: "Edit")
                                    Divider()
                                    ProfileRow(title: "Notifications", value: "Enabled")
                                    Divider()
                                    ProfileRow(title: "Language", value: currentLanguageName)
                                        .onTapGesture {
                                            showLanguagePicker = true
                                        }
                                }
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(white: 0.91), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 24)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("SUPPORT")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.5)
                                
                                VStack(spacing: 0) {
                                    ProfileRow(title: "Terms & Conditions", value: "")
                                    Divider()
                                    ProfileRow(title: "Privacy Policy", value: "")
                                    Divider()
                                    ProfileRow(title: "Contact Support", value: "")
                                }
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(white: 0.91), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 24)
                            
                            Button(action: {
                                UserDefaults.standard.removeObject(forKey: "authToken")
                                UserDefaults.standard.removeObject(forKey: "userFullName")
                                UserDefaults.standard.removeObject(forKey: "userEmail")
                                isAuthenticated = false
                            }) {
                                Text("LOG OUT")
                                    .font(.system(size: 14, weight: .semibold))
                                    .tracking(1.5)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color.black)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 10)
                            
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Profile")
                .onAppear {
                    userFullName = UserDefaults.standard.string(forKey: "userFullName") ?? "Guest User"
                    userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "guest@example.com"
                }
                .confirmationDialog("Change Language", isPresented: $showLanguagePicker, titleVisibility: .visible) {
                    Button("English") { appLanguage = "en" }
                    Button("Русский") { appLanguage = "ru" }
                    Button("Қазақша") { appLanguage = "kk" }
                    Button("Cancel", role: .cancel) {}
                }
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
        .accentColor(.black)
    }
}

struct ProfileRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(.system(size: 14, weight: .light))
                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
            
            Spacer()
            
            if !value.isEmpty {
                Text(LocalizedStringKey(value))
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.secondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(Color(white: 0.7))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}
