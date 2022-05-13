import SwiftUI

@main
struct watch_with_iosApp: App {
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView(model: model) //.environmentObject(model)
        }
    }
}
