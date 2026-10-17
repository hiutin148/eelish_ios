import SwiftUI

struct AppButtonStyle: ButtonStyle {
    enum Variant { case primary, secondary, outline, ghost, danger }
    
    enum Size {
        case small, medium, large
        
        var verticalPadding: CGFloat {
            switch self { case .small: 8; case .medium: 12; case .large: 16 }
        }
        var horizontalPadding: CGFloat {
            switch self { case .small: 16; case .medium: 20; case .large: 24 }
        }
        var font: Font {
            switch self {
            case .small:  .subheadline.weight(.semibold)
            case .medium: .body.weight(.semibold)
            case .large:  .title3.weight(.semibold)
            }
        }
    }
    
    static let cornerRadius: CGFloat = 20
    
    var variant: Variant = .primary
    var size: Size = .medium
    var fullWidth = false
    var customBackground: Color? = nil
    var borderColor: Color? = nil
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: Self.cornerRadius)
        let pressed = configuration.isPressed
        
        configuration.label
            .font(size.font)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor(pressed: pressed), in: shape)
            .overlay {
                if variant == .outline {
                    shape.strokeBorder(borderColor ?? Color.appPrimary, lineWidth: 1.5)
                }
            }
            .contentShape(shape)
            .shadow(
                color: shadowColor,
                radius: pressed ? 12 : 20,
                x: 0,
                y: pressed ? 4 : 10
            )
            .opacity(isEnabled ? 1 : 0.5)
            .animation(.easeOut(duration: 0.15), value: pressed)
            .sensoryFeedback(.impact(weight: .light), trigger: pressed) { _, new in new }
    }
    
    private var shadowColor: Color {
        guard isEnabled, variant == .primary else { return .clear }
        return .black.opacity(0.28)
    }
    
    private func backgroundColor(pressed: Bool) -> Color {
        let base: Color = customBackground ?? {
            switch variant {
            case .primary:   Color.appPrimary
            case .secondary: Color.secondary
            case .danger:    Color.dangerBackground
            case .ghost, .outline: Color.clear
            }
        }()
        return pressed ? base.opacity(0.8) : base
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary:   .primaryForeground
        case .secondary: .secondaryForeground
        case .danger:    .dangerForeground
        case .ghost:     .primary
        case .outline:   .accentColor
        }
    }
}

extension ButtonStyle where Self == AppButtonStyle {
    static var appPrimary: AppButtonStyle { .init(variant: .primary) }
    static var appSecondary: AppButtonStyle { .init(variant: .secondary) }
    static var appGhost: AppButtonStyle { .init(variant: .ghost) }
    static var appDanger: AppButtonStyle { .init(variant: .danger) }
    static var appOutline: AppButtonStyle { .init(variant: .outline) }
    
    static func app(
        _ variant: AppButtonStyle.Variant,
        size: AppButtonStyle.Size = .medium,
        fullWidth: Bool = false,
        background: Color? = nil,
        borderColor: Color? = nil
    ) -> AppButtonStyle {
        .init(variant: variant, size: size, fullWidth: fullWidth, customBackground: background, borderColor: borderColor)
    }
}
