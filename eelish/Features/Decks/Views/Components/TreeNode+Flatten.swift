import Foundation
import SwiftUI

/// Một hàng đang hiển thị trên màn hình
struct FlatRow: Identifiable {
    let node: TreeNode
    let level: Int
    let parentID: String?
    let siblingIndex: Int
    let siblingCount: Int

    var id: String { node.id }
    var hasChildren: Bool { !node.children.isEmpty }
}

extension Array where Element == TreeNode {

    /// Cây -> danh sách phẳng. Chỉ chèn con của node đang mở.
    func flattened(
        expanded: Set<String>,
        level: Int = 0,
        parentID: String? = nil
    ) -> [FlatRow] {
        var result: [FlatRow] = []
        for (index, node) in enumerated() {
            result.append(
                FlatRow(
                    node: node,
                    level: level,
                    parentID: parentID,
                    siblingIndex: index,
                    siblingCount: count
                )
            )
            if expanded.contains(node.id) {
                result += node.children.flattened(
                    expanded: expanded,
                    level: level + 1,
                    parentID: node.id
                )
            }
        }
        return result
    }

    /// Đổi chỗ một node trong nhóm anh em của `parentID` (nil = cấp gốc)
    mutating func moveChild(parentID: String?, from: Int, to: Int) {
        let toOffset = to > from ? to + 1 : to

        guard let parentID else {
            self.move(fromOffsets: IndexSet(integer: from), toOffset: toOffset)
            return
        }
        for i in indices {
            if self[i].id == parentID {
                self[i].children.move(fromOffsets: IndexSet(integer: from), toOffset: toOffset)
                return
            }
            self[i].children.moveChild(parentID: parentID, from: from, to: to)
        }
    }
}
