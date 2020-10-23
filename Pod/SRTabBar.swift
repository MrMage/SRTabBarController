//
//  SRTabBar.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBar: NSView {
	var layoutGuideConstraint: NSLayoutConstraint?
	
	/// The colour used for active items
	open var textTintColor = NSColor.yellow
	open var imageTintColor = NSColor.yellow
	
    /// The colour used for inactive items
    open var textColor = NSColor.white
    
    /// The items that are displayed on the tab bar.
    /// When set, the tabs will be added to a stack view.
    open var items = [SRTabItem]() {
        didSet {
			stack.removeFromSuperview()
            stack = NSStackView(views: items.sorted { $0.index < $1.index })
			stack.translatesAutoresizingMaskIntoConstraints = false
			let itemSpacing: CGFloat = 20
			stack.spacing = itemSpacing
			self.addSubview(stack)

			stack.alignment = .centerX

			let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stack]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["stack": stack])
			self.addConstraints(horizontal)

			if let layoutGuide = self.window?.contentLayoutGuide as? NSLayoutGuide {
				layoutGuideConstraint = layoutGuide.topAnchor.constraint(equalTo: stack.topAnchor, constant: -0.5 * (itemSpacing + 8))
				layoutGuideConstraint?.isActive = true
			} else {
				let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-44-[stack]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["stack": stack])
				self.addConstraints(vertical)

				layoutGuideConstraint = nil
			}
        }
    }
    
    /// The stack view that is added to the bar.
    /// This view contains all of the items.
    fileprivate var stack = NSStackView()

    
    /**
     Set the active item on the tab bar
     
     - parameter index: The index to add
     */
    public func setActive(_ index: Int) {
        guard let views = stack.views as? [SRTabItem] else {
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
