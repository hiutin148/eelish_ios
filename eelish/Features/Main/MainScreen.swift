import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var isStudying = false
}

enum AppTab: String, CaseIterable, Identifiable {
    case today, deck, stats, settings
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .today: "Today"
        case .deck: "Deck"
        case .stats: "Stats"
        case .settings: "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .today: "book.pages"
        case .deck: "rectangle.stack"
        case .stats: "chart.bar"
        case .settings: "gearshape"
        }
    }
}

struct MainScreen : View {
    @Environment(\.container) private var container
    @State private var selection: AppTab = .today
    @ObservedObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            screen(.today) { TodayScreen() }
            screen(.deck) { DeckScreen(viewModel: container.makeDeckViewModel()) }
            screen(.stats) { StatsScreen() }
            screen(.settings) { SettingScreen() }
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selection: $selection)
        }
        .fullScreenCover(isPresented: $appState.isStudying) {
            StudyScreen()
        }
        .environmentObject(appState)
    }
    
    private func screen<Content: View>(
        _ tab: AppTab,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .opacity(selection == tab ? 1 : 0)
            .allowsHitTesting(selection == tab)
            .accessibilityHidden(selection != tab)
    }
}

struct CustomTabBar: View {
    @Binding var selection: AppTab
    @Namespace private var namespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        selection = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .semibold))
                        Text(tab.title)
                            .font(.caption2)
                    }
                    .foregroundStyle(selection == tab ? Color.appPrimary : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color(.white).ignoresSafeArea(edges: .bottom))
        .overlay(alignment: .top) { Divider() }
    }
}
