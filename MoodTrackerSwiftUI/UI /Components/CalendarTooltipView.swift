//
//  CalendarTooltipView.swift
//  MoodTrackerSwiftUI
//
//  Created by ANTON DOBRYNIN on 10.01.2023.
//

import UIKit

final class TooltipView: UIView {
    
    init(backgroundColor: UIColor, borderColor: UIColor, font: UIFont, textColor: UIColor) {
        super.init(frame: .zero)
        
        backgroundView.backgroundColor = backgroundColor
        backgroundView.layer.borderColor = borderColor.cgColor
        addSubview(backgroundView)
        
        label.font = font
        label.textColor = textColor
        addSubview(label)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var text: String {
        get { label.text ?? "" }
        set { label.text = newValue }
    }
    
    var frameOfTooltippedItem: CGRect? {
        didSet {
            guard frameOfTooltippedItem != oldValue else { return }
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let frameOfTooltippedItem = frameOfTooltippedItem else { return }
        
        label.sizeToFit()
        let labelSize = CGSize(
            width: min(label.bounds.size.width, bounds.width),
            height: label.bounds.size.height)
        
        let backgroundSize = CGSize(width: labelSize.width + 16, height: labelSize.height + 16)
        
        let proposedFrame = CGRect(
            x: frameOfTooltippedItem.midX - (backgroundSize.width / 2),
            y: frameOfTooltippedItem.minY - backgroundSize.height - 4,
            width: backgroundSize.width,
            height: backgroundSize.height)
        
        let frame: CGRect
        if proposedFrame.maxX > bounds.width {
            frame = proposedFrame.applying(.init(translationX: bounds.width - proposedFrame.maxX, y: 0))
        } else if proposedFrame.minX < 0 {
            frame = proposedFrame.applying(.init(translationX: -proposedFrame.minX, y: 0))
        } else {
            frame = proposedFrame
        }
        
        backgroundView.frame = frame
        label.center = backgroundView.center
    }
    
    // MARK: Private
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 6
        view.layer.shadowColor = UIColor(Colors.TextColors.cadetBlue600).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
}
