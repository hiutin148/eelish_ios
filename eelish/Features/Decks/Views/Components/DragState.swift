import SwiftUI

struct DragState {
    var id: String?
    var startIndex: Int?
    var translation: CGFloat = 0
    /// Các node bị thu gọn tạm lúc kéo, thả xong sẽ mở lại
    var collapsedIDs: Set<String> = []

    var isActive: Bool { id != nil }

    func isDragging(_ rowID: String) -> Bool { id == rowID }

    /// Độ lệch dọc để hàng đang kéo bám theo ngón tay
    func offset(forRow rowID: String, at index: Int, rowHeight: CGFloat) -> CGFloat {
        guard isDragging(rowID), let startIndex else { return 0 }
        return translation - CGFloat(index - startIndex) * rowHeight
    }

    mutating func reset() {
        self = DragState()
    }
}

