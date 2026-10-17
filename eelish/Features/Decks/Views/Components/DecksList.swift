import SwiftUI

struct DecksList: View {
    @Binding var decks: [TreeNode]
    let onDeckTap: (String) -> Void

    @State private var expandedIDs: Set<String> = []
    @State private var drag = DragState()
    @Binding var draggable: Bool
    @State private var movingRow: FlatRow?

    private var allParentIDs: Set<String> {
        func collect(_ nodes: [TreeNode]) -> Set<String> {
            var result = Set<String>()
            for node in nodes where !node.children.isEmpty {
                result.insert(node.id)
                result.formUnion(collect(node.children))
            }
            return result
        }
        return collect(decks)
    }

    private var fullRows: [FlatRow] {
        decks.flattened(expanded: allParentIDs)
    }

    var body: some View {
        let rows = decks.flattened(expanded: expandedIDs)

        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    DeckItem(
                        index: index,
                        row: row,
                        isExpanded: expandedIDs.contains(row.id),
                        isLast: index == rows.count - 1,
                        drag: drag,
                        onToggle: { toggle(row.id) },
                        onTap: { onDeckTap(row.id) },
                        onMoveTap: { movingRow = row },
                        onDragChanged: { handleDragChanged(id: row.id, translation: $0, height: $1) },
                        onDragEnded: { handleDragEnded(id: row.id, height: $0) },
                        draggable: $draggable
                    )
                    .zIndex(drag.isDragging(row.id) ? 1 : 0)
                }
            }
            .frame(maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .onChange(of: draggable) { _, isDraggable in
            guard isDraggable else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                expandedIDs = allParentIDs
            }
        }
        .sheet(item: $movingRow) { moving in
            ReorderSheet(
                decks: fullRows,
                moveDeck: moving,
                onConfirm: { newParent in move(moving, to: newParent) }
            )
            .presentationDetents([.large])
        }
    }

    // MARK: - Chuyển deck

    private func move(_ moving: FlatRow, to newParent: FlatRow?) {
        withAnimation(.snappy(duration: 0.25)) {
            guard let node = decks.removeNode(id: moving.id) else { return }
            if let newParent {
                decks.appendChild(node, toParent: newParent.id)
                expandedIDs.insert(newParent.id)
            } else {
                decks.append(node)
            }
        }
    }

    // MARK: - Mở / đóng

    private func toggle(_ id: String) {
        withAnimation(.snappy(duration: 0.25)) {
            if expandedIDs.contains(id) {
                expandedIDs.remove(id)
            } else {
                expandedIDs.insert(id)
            }
        }
    }

    // MARK: - Drag: 3 bước

    private func handleDragChanged(id: String, translation: CGFloat, height: CGFloat) {
        guard height > 0 else { return }

        if !drag.isActive { beginDrag(id: id) }

        drag.translation = translation
        reorderIfNeeded(id: id, height: height)
    }

    /// Bước 1: ghi nhớ hàng đang kéo, thu gọn các anh em để các hàng cùng chiều cao
    private func beginDrag(id: String) {
        let rows = decks.flattened(expanded: expandedIDs)
        guard let index = rows.firstIndex(where: { $0.id == id }) else { return }

        drag.id = id
        drag.startIndex = index

        let parentID = rows[index].parentID
        let siblingIDs = Set(rows.filter { $0.parentID == parentID }.map(\.id))
        drag.collapsedIDs = expandedIDs.intersection(siblingIDs)
        expandedIDs.subtract(drag.collapsedIDs)
    }

    /// Bước 2: nếu kéo qua một slot thì đổi chỗ (chỉ trong nhóm anh em)
    private func reorderIfNeeded(id: String, height: CGFloat) {
        let rows = decks.flattened(expanded: expandedIDs)
        guard let start = drag.startIndex,
              let current = rows.firstIndex(where: { $0.id == id }) else { return }

        let row = rows[current]
        let firstSibling = current - row.siblingIndex
        let lastSibling = firstSibling + row.siblingCount - 1

        let slots = Int((drag.translation / height).rounded())
        let target = min(max(start + slots, firstSibling), lastSibling)
        guard target != current else { return }

        withAnimation(.snappy(duration: 0.25)) {
            decks.moveChild(
                parentID: row.parentID,
                from: row.siblingIndex,
                to: row.siblingIndex + (target - current)
            )
        }
    }

    /// Bước 3: hàng trượt về đúng slot, rồi dọn dẹp và mở lại các node đã thu gọn
    private func handleDragEnded(id: String, height: CGFloat) {
        let rows = decks.flattened(expanded: expandedIDs)
        guard let start = drag.startIndex,
              let current = rows.firstIndex(where: { $0.id == id }) else {
            finishDrag()
            return
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            drag.translation = CGFloat(current - start) * height
        } completion: {
            finishDrag()
        }
    }

    private func finishDrag() {
        let collapsed = drag.collapsedIDs
        drag.reset()
        withAnimation(.snappy(duration: 0.25)) {
            expandedIDs.formUnion(collapsed)
        }
    }
}

// MARK: - Tree helpers

extension Array where Element == TreeNode {
    /// Gỡ node (kèm cả nhánh con) khỏi cây, ở bất kỳ cấp nào
    @discardableResult
    mutating func removeNode(id: String) -> TreeNode? {
        if let i = firstIndex(where: { $0.id == id }) {
            return remove(at: i)
        }
        for i in indices {
            if let removed = self[i].children.removeNode(id: id) { return removed }
        }
        return nil
    }

    /// Thêm node vào cuối danh sách con của parentID
    @discardableResult
    mutating func appendChild(_ node: TreeNode, toParent parentID: String) -> Bool {
        for i in indices {
            if self[i].id == parentID {
                self[i].children.append(node)
                return true
            }
            if self[i].children.appendChild(node, toParent: parentID) { return true }
        }
        return false
    }
}

#Preview {
    NavigationStack {
        DeckScreen(viewModel: AppContainer.live().makeDeckViewModel())
    }
    .environment(\.container, .live())
}
