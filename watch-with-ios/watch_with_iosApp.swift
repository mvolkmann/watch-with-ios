import SwiftUI

// iOS app
@main
struct watch_with_iosApp: App {
    @StateObject private var model = Model.instance

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }
    }
}
