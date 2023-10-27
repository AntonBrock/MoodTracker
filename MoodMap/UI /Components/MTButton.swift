//
//  MTButton.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 19.09.2022.
//

import SwiftUI

enum MTButtonColorStyle {
    case fill
    case outline
    case deleteAction
}

struct MMButtonSelecting: View {
    struct Size {
        static let height: CGFloat = 45
        static let width: CGFloat = 250
    }
    
    @State var title: String
    @State var handle: (() -> Void)
    
    @Binding var isSelectedButton: Bool
    
    var body: some View {
        Button("\(title)") {
            handle()
        }
        .buttonStyle(MMSelectingButtonStyle(isSelectedButton: isSelectedButton))
    }
}

private extension MMButtonSelecting {
    struct MMSelectingButtonStyle: ButtonStyle {
        @Environment(\.isEnabled) private var isEnabled
        
        var isSelectedButton: Bool

        var defaultTextColor: Color {
            return isSelectedButton ? Colors.Primary.lavender500Purple : Colors.Primary.blue
        }
        
        var pressedTextColor: Color {
            return isSelectedButton ? Colors.Primary.lavender500Purple : Colors.Primary.blue
        }
        
        var disabledTextColor: Color {
            return Colors.TextColors.mischka500
        }
        
        var defaultBackgroundColor: Color {
            return Color.white
        }
        
        var pressedBackgroundColor: Color {
            return Color.white
        }
        
        var disabledBackgroundColor: Color {
            return Colors.TextColors.athensGray300
        }
        
        var defaultBorderColor: Color {
            return isSelectedButton ? Colors.Primary.lavender500Purple : .clear
        }
        
        var pressedBorderColor: Color {
            return isSelectedButton ? Colors.Primary.lavender500Purple : .clear
        }
        
        var disabledBorderColor: Color {
            return Colors.Primary.lavender500Purple
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size:  16,
                              weight: .bold))
                .foregroundColor(
                    isEnabled
                    ? configuration.isPressed
                    ? pressedTextColor
                    : defaultTextColor
                    : disabledTextColor
                )
                .padding(.vertical, 15)
                .background(
                    isEnabled
                    ? configuration.isPressed
                    ? pressedBackgroundColor
                    : defaultBackgroundColor
                    : disabledBackgroundColor
                )
                .cornerRadius(30)
                .background(
                    RoundedRectangle(
                        cornerRadius: 30,
                        style: .continuous
                    )
                    .stroke(lineWidth: 1.5)
                    .stroke(
                        isEnabled
                        ? configuration.isPressed
                        ? pressedBorderColor
                        : defaultBorderColor
                        : disabledBorderColor
                    )
                )
                .scaleEffect(1.0)
                .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
        }
        
    }
}

struct MTButton: View {
    
    struct Size {
        static let height: CGFloat = 45
        static let width: CGFloat = 250
    }

    let buttonStyle: MTButtonColorStyle
    @State var title: String
    @State var handle: (() -> Void)
    
    var body: some View {
        Button("\(title)") {
            handle()
        }
        .buttonStyle(CBButtonStyle(buttonColorStyle: buttonStyle))
    }
}

extension MTButton {
    struct CBButtonStyle: ButtonStyle {
        @Environment(\.isEnabled) private var isEnabled
        
        let buttonColorStyle: MTButtonColorStyle
        var isLoading: Bool = false
        
        var defaultTextColor: Color {
            switch buttonColorStyle {
            case .fill: return Color.white
            case .outline: return Colors.Primary.lavender500Purple
            case .deleteAction: return Colors.Secondary.crimson600Red
            }
        }
        
        var pressedTextColor: Color {
            switch buttonColorStyle {
            case .fill: return Color.white
            case .outline: return Color.white
            case .deleteAction: return Color.white
            }
        }
        
        var disabledTextColor: Color {
            switch buttonColorStyle {
            case .fill, .outline, .deleteAction: return Colors.TextColors.mischka500
            }
        }
        
        var defaultBackgroundColor: Color {
            switch buttonColorStyle {
            case .fill: return Colors.Primary.lavender500Purple
            case .outline: return Color.white
            case .deleteAction: return Color.white
            }
        }
        
        var pressedBackgroundColor: Color {
            switch buttonColorStyle {
            case .fill: return Colors.Primary.lavender500Purple
            case .outline: return Colors.Primary.lavender500Purple
            case .deleteAction: return Colors.Secondary.crimson600Red
            }
        }
        
        var disabledBackgroundColor: Color {
            switch buttonColorStyle {
            case .fill, .outline, .deleteAction: return Colors.TextColors.athensGray300
            }
        }
        
        var defaultBorderColor: Color {
            switch buttonColorStyle {
            case .fill: return Color.white
            case .outline: return Colors.Primary.lavender500Purple
            case .deleteAction: return Colors.Secondary.crimson600Red

            }
        }
        
        var pressedBorderColor: Color {
            switch buttonColorStyle {
            case .fill: return Color.white
            case .outline: return Colors.Primary.lavender500Purple
            case .deleteAction: return Colors.Secondary.crimson600Red
            }
        }
        
        var disabledBorderColor: Color {
            switch buttonColorStyle {
            case .fill: return Color.white
            case .outline: return Colors.Primary.lavender500Purple
            case .deleteAction: return Colors.Secondary.crimson600Red
            }
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration
                .label
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: buttonColorStyle == .fill ? 14 : 16,
                              weight: buttonColorStyle == .fill ? .bold : .regular))
                .foregroundColor(
                    isEnabled
                    ? configuration.isPressed
                    ? pressedTextColor
                    : defaultTextColor
                    : disabledTextColor
                )
                .padding(.vertical, 15)
                .background(
                    isEnabled
                    ? configuration.isPressed
                    ? pressedBackgroundColor
                    : defaultBackgroundColor
                    : disabledBackgroundColor
                )
                .cornerRadius(30)
                .background(
                    RoundedRectangle(
                        cornerRadius: 30,
                        style: .continuous
                    )
                    .stroke(lineWidth: 1.5)
                    .stroke(
                        isEnabled
                        ? configuration.isPressed
                        ? pressedBorderColor
                        : defaultBorderColor
                        : disabledBorderColor
                    )
                )
                .scaleEffect(isLoading ? 1.0 : configuration.isPressed ? 0.93 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: configuration.isPressed)
        }
    }
}
