import SwiftUI

@main
struct BookTableApp: App {
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    
    var body: some Scene {
        WindowGroup {
            CheckEmailView()
                .environment(\.locale, .init(identifier: appLanguage))
        }
    }
}
