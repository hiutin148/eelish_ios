import SwiftUI

struct ProgressRing : View {
    let progress: CGFloat
    var size: CGFloat = 46
    var color: Color = Color.green
    var strokeWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.mutedForeground.opacity(0.3), lineWidth: strokeWidth)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, lineWidth: strokeWidth)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: progress)
        }.frame(width: size, height: size, alignment: Alignment.center)
        
    }
}

#Preview {
    ProgressRing(progress: 0.9,size: 46)
}
