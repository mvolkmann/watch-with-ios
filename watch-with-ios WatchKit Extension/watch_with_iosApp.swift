import SwiftUI

// watchOS app
@main
struct watch_with_iosApp: App {
    @StateObject private var model = Model.instance

    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
        }

        WKNotificationScene(
            controller: NotificationController.self,
            category: "myCategory"
        )
    }
}
