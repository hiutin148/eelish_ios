import SwiftUI

struct MainTabHeader : View {
    let title: String
    var subTitle: String? = nil
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 26).weight(.bold))
            if (subTitle != nil) {
                Text(subTitle ?? "")
                    .font(.system(size: 13))
                    .foregroundStyle(.mutedForeground)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}
