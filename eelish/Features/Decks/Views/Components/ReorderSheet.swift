import SwiftUI

struct ReorderSheet: View {
    let decks: [FlatRow]
    let moveDeck: FlatRow
    let onConfirm: (FlatRow?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var selectedID: FlatRow.ID?

    private let maxLevel = 2
    private let indentWidth: CGFloat = 16

    init(decks: [FlatRow], moveDeck: FlatRow, onConfirm: @escaping (FlatRow?) -> Void) {
        self.decks = decks
        self.moveDeck = moveDeck
        self.onConfirm = onConfirm
        _selectedID = State(initialValue: Self.parent(of: moveDeck, in: decks)?.id)
    }

    private var currentParent: FlatRow? { Self.parent(of: moveDeck, in: decks) }

    private var subtree: [FlatRow] {
        guard let start = decks.firstIndex(where: { $0.id == moveDeck.id }) else { return [] }
        return decks[(start + 1)...].prefix { $0.level > moveDeck.level }.map { $0 }
    }

    private var descendantIDs: Set<FlatRow.ID> { Set(subtree.map(\.id)) }

    private var subtreeDepth: Int {
        (subtree.map(\.level).max() ?? moveDeck.level) - moveDeck.level
    }

    private var selectedTitle: String {
        decks.first { $0.id == selectedID }?.node.title ?? "Top level"
    }

    private var isUnchanged: Bool { selectedID == currentParent?.id }

    private func disabledReason(for row: FlatRow) -> String? {
        if row.id == moveDeck.id { return "This deck" }
        if descendantIDs.contains(row.id) { return "Inside this deck" }
        if row.level + 1 + subtreeDepth > maxLevel { return "Max depth reached" }
        return nil
    }

    private static func parent(of deck: FlatRow, in rows: [FlatRow]) -> FlatRow? {
        guard deck.level > 0,
              let index = rows.firstIndex(where: { $0.id == deck.id }) else { return nil }
        return rows[..<index].last { $0.level == deck.level - 1 }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Move \"\(moveDeck.node.title)\"")
                    .font(.system(size: 24).weight(.semibold))
                Text("Currently in \(currentParent?.node.title ?? "Top level")")
                    .font(.system(size: 13))
                    .foregroundStyle(.mutedForeground)
                Text("Decks can be nested up to 3 levels deep.")
                    .font(.system(size: 13))
                    .foregroundStyle(.mutedForeground)

                VStack(spacing: 0) {
                    destinationRow(
                        title: "Top level",
                        subtitle: "Show at the root of your Decks list",
                        level: 0,
                        showsDot: false,
                        isSelected: selectedID == nil,
                        isCurrent: currentParent == nil,
                        reason: nil
                    ) { selectedID = nil }

                    ForEach(decks) { row in
                        Divider()
                        let reason = disabledReason(for: row)
                        destinationRow(
                            title: row.node.title,
                            subtitle: reason,
                            level: row.level,
                            showsDot: true,
                            isSelected: selectedID == row.id,
                            isCurrent: currentParent?.id == row.id,
                            reason: reason
                        ) { selectedID = row.id }
                    }
                }
                .background(Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .background(Color.background)
        .safeAreaInset(edge: .bottom) { confirmButton }
        .presentationDragIndicator(.visible)
    }

    private var confirmButton: some View {
        Button {
            onConfirm(decks.first { $0.id == selectedID })
            dismiss()
        } label: {
            Text("Move to \(selectedTitle)")
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.primaryForeground)
                .background(Color.accentColor.opacity(isUnchanged ? 0.4 : 1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isUnchanged)
        .padding(.horizontal)
        .padding(.bottom, 8)
        .padding(.top, 12)
        .background(.regularMaterial)
    }

    private func destinationRow(
        title: String,
        subtitle: String?,
        level: Int,
        showsDot: Bool,
        isSelected: Bool,
        isCurrent: Bool,
        reason: String?,
        action: @escaping () -> Void
    ) -> some View {
        let isDisabled = reason != nil

        return Button(action: action) {
            HStack(spacing: 12) {
                radio(isSelected: isSelected)

                if showsDot {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 6, height: 6)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .lineLimit(1)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundStyle(.mutedForeground)
                    }
                }

                Spacer(minLength: 0)

                if isCurrent {
                    Text("Current")
                        .font(.system(size: 11, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.accentColor.opacity(0.12))
                        .foregroundStyle(Color.accentColor)
                        .clipShape(Capsule())
                }
            }
            .padding(.leading, 16 + CGFloat(level) * indentWidth)
            .padding(.trailing, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .opacity(isDisabled ? 0.4 : 1)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    private func radio(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .strokeBorder(isSelected ? Color.accentColor : Color.mutedForeground.opacity(0.5), lineWidth: 1.5)
                .background(Circle().fill(isSelected ? Color.accentColor : .clear))
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.primaryForeground)
            }
        }
        .frame(width: 22, height: 22)
    }
}

#Preview {
    NavigationStack {
        DeckScreen(viewModel: AppContainer.live().makeDeckViewModel())
    }
    .environment(\.container, .live())
}

