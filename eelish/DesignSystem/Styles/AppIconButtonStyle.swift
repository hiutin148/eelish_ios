import SwiftUI

struct AppIconButtonStyle: ButtonStyle {
    enum Variant {
        case primary, secondary, outline, ghost, danger, muted
    }
    
    enum Size {
        case small, medium, large
        
        var dimension: CGFloat {
            switch self {
            case .small: 32
            case .medium: 40
            case .large: 48
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: 14
            case .medium: 18
            case .large: 22
            }
        }
    }
    
    var variant: Variant = .primary
    var size: Size = .medium
    var customBackground: Color? = nil
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed
        
        configuration.label
            .font(.system(size: size.iconSize, weight: .semibold))
            .frame(width: size.dimension, height: size.dimension)
            .foregroundStyle(foregroundColor)
            .background(
                backgroundColor(pressed: pressed),
                in: Circle()
            )
            .overlay {
                if variant == .outline {
                    Circle()
                        .strokeBorder(Color.accentColor, lineWidth: 1.5)
                }
            }
            .contentShape(Circle())
            .opacity(isEnabled ? 1 : 0.5)
            .animation(.easeOut(duration: 0.15), value: pressed)
            .sensoryFeedback(
                .impact(weight: .light),
                trigger: pressed
            ) { _, new in new }
    }
    
    private func backgroundColor(pressed: Bool) -> Color {
        let base: Color = customBackground ?? {
            switch variant {
            case .primary: Color.appPrimary
            case .secondary: Color.secondary
            case .danger: Color.dangerBackground
            case .ghost, .outline: Color.clear
            case .muted: Color.muted
            }
        }()
        
        return pressed ? base.opacity(0.8) : base
    }
    
    private var foregroundColor: Color {
        switch variant {
        case .primary: .primaryForeground
        case .secondary: .secondaryForeground
        case .danger: .dangerForeground
        case .ghost: .primary
        case .outline: .accentColor
        case .muted: Color.foreground
        }
    }
}

extension ButtonStyle where Self == AppIconButtonStyle {
    static var appIconPrimary: AppIconButtonStyle {
        .init(variant: .primary)
    }
    
    static var appIconSecondary: AppIconButtonStyle {
        .init(variant: .secondary)
    }
    
    static var appIconGhost: AppIconButtonStyle {
        .init(variant: .ghost)
    }
    
    static var appIconDanger: AppIconButtonStyle {
        .init(variant: .danger)
    }
    
    static var appIconOutline: AppIconButtonStyle {
        .init(variant: .outline)
    }
    
    static var appIconMuted: AppIconButtonStyle {
        .init(variant: .muted, size: .small)
    }
    
    static func appIcon(
        _ variant: AppIconButtonStyle.Variant,
        size: AppIconButtonStyle.Size = .medium,
        background: Color? = nil
    ) -> AppIconButtonStyle {
        .init(
            variant: variant,
            size: size,
            customBackground: background
        )
    }
}
