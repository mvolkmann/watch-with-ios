import SwiftUI

// watchOS app
@main
struct watch_with_iosApp: App {
    @StateObject private var model = Model()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView(model).environmentObject(model)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
