//
//  watch_with_iosApp.swift
//  watch-with-ios WatchKit Extension
//
//  Created by Mark Volkmann on 5/11/22.
//

import SwiftUI

@main
struct watch_with_iosApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
