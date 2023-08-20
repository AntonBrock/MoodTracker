//
//  AuthHyperString.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 27.01.2023.
//

import UIKit
import SwiftUI

struct AuthHyperString: UIViewRepresentable {
        
    func makeUIView(context: Context) -> UITextView {
        
        let standartTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: UIColor(Color(hex: "B4B6B8"))
        ]
        
        let attributedText = NSMutableAttributedString(string: "Нажимая на кнопки «Продолжить с Google/Apple», вы принимаете нашу:")
        attributedText.addAttributes(standartTextAttributes, range: attributedText.range) // check extention
        
        let hyperlinkTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: UIColor(Color(hex: "B283E4")),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.link: "https://mapmood.com/privacy"
        ]
        
        let textWithHyperlink = NSMutableAttributedString(string: " политику конфидициальности ")
        textWithHyperlink.addAttributes(hyperlinkTextAttributes, range: textWithHyperlink.range)
        attributedText.append(textWithHyperlink)
        
        let subEndOfAttrString = NSMutableAttributedString(string: " и ")
        subEndOfAttrString.addAttributes(standartTextAttributes, range: subEndOfAttrString.range)
        attributedText.append(subEndOfAttrString)
        
        let hyperlinkTextAttributesTwo: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11),
            NSAttributedString.Key.foregroundColor: UIColor(Color(hex: "B283E4")),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.link: "https://mapmood.com/terms"
        ]
        
        let endOfAttrString = NSMutableAttributedString(string: " правила использования приложения")
        endOfAttrString.addAttributes(hyperlinkTextAttributesTwo, range: endOfAttrString.range)
        attributedText.append(endOfAttrString)
                
        let textView = UITextView()
        textView.attributedText = attributedText
        
        textView.isEditable = false
        textView.textAlignment = .center
        textView.isSelectable = true
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {}
}

extension NSMutableAttributedString {
    var range: NSRange {
        NSRange(location: 0, length: self.length)
    }
}
