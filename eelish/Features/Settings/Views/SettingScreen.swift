import SwiftUI

struct SettingScreen : View {
    @EnvironmentObject private var sessionVm: SessionViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    MainTabHeader(title: "Settings")
                    VStack {
                        SettingStudySection()
                        SettingNotificationSection()
                        Button {
                            Task {
                                await sessionVm.logout()
                            }
                        } label: {
                            Text("Logout")
                        }.buttonStyle(.appDanger)
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, geometry.safeAreaInsets.top)
                .padding(.bottom, geometry.safeAreaInsets.bottom)
            }
            .frame(width: geometry.size.width)
            .background(Color.background)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SettingScreen()
}
