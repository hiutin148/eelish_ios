import SwiftUI

@main
struct eelishApp: App {
    @State private var container = AppContainer.live()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
