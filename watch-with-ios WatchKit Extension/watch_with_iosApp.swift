import SwiftUI

@main
struct watch_with_iosApp: App {
    @StateObject private var model = Model()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            // ContentView().environmentObject(model)
            ContentView(model: model)
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
