//
//  Colors.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 14.09.2022.
//

import SwiftUI

struct Colors {
    
    struct Primary {
        static let lightWhite: Color = Color(hex: "#F7F9FA")
        static let blue: Color = Color(hex: "#324260")
        static let lightGray: Color = Color(hex: "#ADB5BD")
        
        static let honeyFlower700Purple: Color = Color(hex: "#4C1B80")
        static let royalPurple600Purple: Color = Color(hex: "#7137AF")
        static let lavender500Purple: Color = Color(hex: "#B283E4")
        static let perfume400Purple: Color = Color(hex: "#CDA8F5")
        static let moonRaker300Purple: Color = Color(hex: "#E2CEF7")
        static let moodDarkBackground: Color = Color(hex: "#24324E")
    }
    
    struct Secondary {
        static let malibu600Blue: Color = Color(hex: "#7392FC")
        static let melrose500Blue: Color = Color(hex: "#B9C8FD")
        static let periwinkle400Blue: Color = Color(hex: "#D7E0FF")
        
        static let crimson600Red: Color = Color(hex: "#DE1314")
        static let carnation500Red: Color = Color(hex: "#FA5555")
        static let yourPinkRed400: Color = Color(hex: "#FFC8C8")
        
        static let shamrock600Green: Color = Color(hex: "#33d299")
        static let riptide500Green: Color = Color(hex: "#86e9c5")
        static let cruise400Green: Color = Color(hex: "#c9f0e2")
        
        static let neonCarrot600Orange: Color = Color(hex: "#ff9636")
        static let peachOrange500Orange: Color = Color(hex: "#ffc794")
        static let negroni400Orange: Color = Color(hex: "#ffe1c6")
        
        static let gold: Color = Color(hex: "#FFD700")
    }
    
    struct TextColors {
        static let cello900: Color = Color(hex: "#1e3559")
        static let fiord800: Color = Color(hex: "#425672")
        static let slateGray700: Color = Color(hex: "#778999")
        static let cadetBlue600: Color = Color(hex: "#a6afc1")
        static let mischka500: Color = Color(hex: "#cfd3dc")
        static let mystic400: Color = Color(hex: "#e4eaee")
        static let athensGray300: Color = Color(hex: "#eff1f4")
        
        static let porcelain200: Color = Color(hex: "#FCFDFD")
        static let white: Color = Color(hex: "ffffff")
    }
}

// MARK: - Color
extension Color {
    init(hex: String) {
           let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
           var int: UInt64 = 0
           Scanner(string: hex).scanHexInt64(&int)
           let a, r, g, b: UInt64
           switch hex.count {
           case 3: // RGB (12-bit)
               (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
           case 6: // RGB (24-bit)
               (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
           case 8: // ARGB (32-bit)
               (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
           default:
               (a, r, g, b) = (1, 1, 1, 0)
           }

           self.init(
               .sRGB,
               red: Double(r) / 255,
               green: Double(g) / 255,
               blue:  Double(b) / 255,
               opacity: Double(a) / 255
           )
       }
}
