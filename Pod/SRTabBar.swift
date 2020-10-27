//
//  SRTabBar.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBar: NSView {
	/// The colour used for active items
	open var textTintColor = NSColor.yellow
	open var imageTintColor = NSColor.yellow
	
    /// The colour used for inactive items
    open var textColor = NSColor.white
    
    /// The items that are displayed on the tab bar.
    /// When set, the tabs will be added to a stack view.
    open var items = [SRTabItem]() {
        didSet {
			stackView.removeFromSuperview()
            stackView = NSStackView(views: items.sorted { $0.index < $1.index })
			stackView.orientation = .vertical
			stackView.translatesAutoresizingMaskIntoConstraints = false
			let itemSpacing: CGFloat = 20
			stackView.spacing = itemSpacing
			self.addSubview(stackView)

			stackView.alignment = .centerY

			let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[stackView]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["stackView": stackView])
			self.addConstraints(horizontal)
			self.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "V:|-8-[stackView]|",
									options: [],
									metrics: nil,
									views: ["stackView": stackView]))
        }
    }
    
    /// The stack view that is added to the bar.
    /// This view contains all of the items.
    fileprivate var stackView = NSStackView()

    
    /**
     Set the active item on the tab bar
     
     - parameter index: The index to add
     */
    public func setActive(_ index: Int) {
        guard let views = stackView.views as? [SRTabItem] else {
            return
        }
		
        for (current, view) in views.enumerated() {
			let active = index == current
			view.textTintColor = active ? textTintColor : textColor
			view.imageTintColor = active ? imageTintColor : textColor
			if #available(OSX 10.14, *) {
				view.imageIsTemplate = true
			} else {
				view.imageIsTemplate = !active
			}
        }
    }
}
