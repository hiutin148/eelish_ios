import SwiftUI

struct ContentView: View {
    private let container: AppContainer
    @StateObject private var sessionVm: SessionViewModel

    init(container: AppContainer) {
        self.container = container
        _sessionVm = StateObject(wrappedValue: container.makeSessionViewModel())
    }

    var body: some View {
        Group {
            switch sessionVm.state {
            case .loading:
                ProgressBar(progress: 0.8)
            case .authenticated:
                MainScreen()
            case .unauthenticated:
                SigninScreen(viewModel: container.makeSigninViewModel())
            }
        }
        .task {
            sessionVm.checkSession()
        }
        .environment(\.container, container)
        .environmentObject(sessionVm)
    }
}

#Preview {
    ContentView(container: .live())
}
