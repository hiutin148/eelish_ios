import SwiftUI

struct SettingStudySection : View {

    var body: some View {
        SettingContainer(title: "STUDY", data: [
            SettingRowData(
                icon: "target",
                title: "Daily new cards"
            ) {
                QuantityController()
            },
            SettingRowData(
                icon: "brain",
                title: "SRS Algorithm"
            ) {
                Text("SM-2")
                    .font(.system(size: 15).weight(.medium))
                    .foregroundStyle(.appPrimary)
            },
            SettingRowData(
                icon: "calendar",
                title: "Easy interval"
            ) {
                Text("4 days")
                    .font(.system(size: 15).weight(.medium))
                    .foregroundStyle(.appPrimary)
            },
            SettingRowData(
                icon: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill",
                title: "New card order"
            ) {
                Text("Random")
                    .font(.system(size: 15).weight(.medium))
                    .foregroundStyle(.appPrimary)
            },
        ])
    }
}
