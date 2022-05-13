import SwiftUI

// iOS app
@main
struct watch_with_iosApp: App {
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView(model).environmentObject(model)
        }
    }
}
