import SwiftUI

struct DeckItem: View {
    let index: Int
    let row: FlatRow
    let isExpanded: Bool
    let isLast: Bool
    let drag: DragState
    
    let onToggle: () -> Void
    let onTap: () -> Void
    let onMoveTap: () -> Void
    let onDragChanged: (_ translation: CGFloat, _ height: CGFloat) -> Void
    let onDragEnded: (_ height: CGFloat) -> Void
    @Binding var draggable: Bool
    
    @State private var itemSize: CGSize = .zero
    
    private let indentWidth: CGFloat = 16
    private var indent: CGFloat { CGFloat(row.level) * indentWidth }
    private var isDragging: Bool { drag.isDragging(row.id) }
    
    var body: some View {
        VStack(spacing: 0) {
            content
                .padding(.leading, 16 + indent)
                .padding(.trailing, 16)
                .padding(.vertical, 14)
            
            if !isLast {
                Divider().padding(.leading, indent)
            }
        }
        .background(Color.card)
        .contentShape(Rectangle())
        .offset(y: drag.offset(forRow: row.id, at: index, rowHeight: itemSize.height))
        .shadow(
            color: .black.opacity(isDragging ? 0.15 : 0),
            radius: isDragging ? 8 : 0,
            x: 0,
            y: isDragging ? 4 : 0
        )
        
        .background(sizeReader)
        
        .onTapGesture {
            if (!draggable) {
                onTap()
            }
        }
        .onLongPressGesture {
            draggable = true
        }
        .allowsHitTesting(!drag.isActive || isDragging)
    }
    
    // MARK: - UI
    
    private var content: some View {
        let progress = 0.5
        let deckColor = Color.red
        let mockDue = 16
        
        return HStack(spacing: 8) {
            expandButton
            if !draggable {
                ProgressRing(progress: progress, size: 36, color: deckColor)
            }
            VStack(alignment: .leading) {
                titleLine(due: mockDue, color: deckColor)
                if !draggable {
                    statsLine
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if (draggable) {
                Button {
                    onMoveTap()
                } label: {
                    Text("Move to ...")
                        .font(.system(size: 14).weight(.semibold))
                        .foregroundStyle(.appPrimary)
                }
                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                    .gesture(dragGesture, including: draggable ? .all : .none)
            }
        }
    }
    
    private func titleLine(due: Int, color: Color) -> some View {
        HStack {
            Text(row.node.title)
                .font(.system(size: 15, weight: .semibold))
                .lineLimit(1)
            
            if due > 0 && !draggable {
                Text("\(due)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.primaryForeground)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(color)
                    .background(color, in: Capsule())
            }
        }
    }
    
    private var statsLine: some View {
        HStack(spacing: 3) {
            Text("\(100) cards")
            Text("·")
            Text("\(20) mastered")
        }
        .font(.caption)
        .foregroundStyle(.mutedForeground)
    }
    
    private var expandButton: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.mutedForeground)
            .rotationEffect(.degrees(isExpanded ? 90 : 0))
            .frame(width: 24, height: 32)
            .contentShape(Rectangle())
            .opacity(row.hasChildren ? 1 : 0)
            .onTapGesture {
                if row.hasChildren { onToggle() }
            }
    }
    
    // MARK: - Gesture & đo kích thước
    
    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { onDragChanged($0.translation.height, itemSize.height) }
            .onEnded { _ in onDragEnded(itemSize.height) }
    }
    
    private var sizeReader: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear { itemSize = geo.size }
                .onChange(of: geo.size) { _, newSize in itemSize = newSize }
        }
    }
}

#Preview {
    NavigationStack {
        DeckScreen(viewModel: AppContainer.live().makeDeckViewModel())
    }
    .environment(\.container, .live())
}
