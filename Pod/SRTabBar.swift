//
//  SRTabBar.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBar: NSVisualEffectView {
	var layoutGuideConstraint: NSLayoutConstraint?

    /// Whether or not the tab bar is translucent
    open var translucent = false {
        didSet {
            state = (translucent) ? .active : .inactive
            backgroundView.isHidden = translucent
        }
    }
    
    /// The background color of the tab bar
    open var backgroundColor = NSColor.black {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    
	/// The colour used for active items
	open var textTintColor = NSColor.yellow
	open var imageTintColor = NSColor.yellow
	
    /// The colour used for inactive items
    open var textColor = NSColor.white
    
    /// Spacing between the items
    open var itemSpacing: CGFloat = 25 {
        didSet {
            stack?.spacing = itemSpacing
        }
    }
    
    /// The items that are displayed on the tab bar.
    /// When set, the tabs will be added to a stack view.
    open var items = [SRTabItem]() {
        didSet {
            
            stack?.removeFromSuperview()
            stack = NSStackView(views: items.sorted { $0.index < $1.index })
            stack?.spacing = itemSpacing
            addSubview(stack!)
            
            if [SRTabLocation.Top, SRTabLocation.Bottom].contains(location) {
                
                let centerX = NSLayoutConstraint(item: stack!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
                let centerY = NSLayoutConstraint(item: stack!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
                
                addConstraints([centerX, centerY])
				
				layoutGuideConstraint = nil
            } else {
                stack?.alignment = .centerX
                
                let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stack]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["stack": stack!])
                
				addConstraints(horizontal)
				
				Swift.print(self.window)
				
				if let layoutGuide = self.window?.contentLayoutGuide as? NSLayoutGuide {
					layoutGuideConstraint = layoutGuide.topAnchor.constraint(equalTo: stack!.topAnchor)
					layoutGuideConstraint?.isActive = true
				} else {
					let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-44-[stack]", options: NSLayoutFormatOptions(), metrics: nil, views: ["stack": stack!])
					addConstraints(vertical)
					
					layoutGuideConstraint = nil
				}
            }
        
        }
    }
    
    internal var location: SRTabLocation = .Bottom
    
    /// The stack view that is added to the bar.
    /// This view contains all of the items.
    fileprivate var stack: NSStackView?
    
    fileprivate var backgroundView = SRTabBarBackground()
    
    // MARK: - Methods
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        wantsLayer = true
        
        backgroundView.frame = NSZeroRect
        backgroundView.backgroundColor = backgroundColor
        addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": backgroundView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["subview": backgroundView]))
        
        state = .inactive
    }

    
    /**
     Set the active item on the tab bar
     
     - parameter index: The index to add
     */
    internal func setActive(_ index: Int) {
        guard let views = stack?.views as? [SRTabItem] else {
            return
        }
		
		let isVibrant = self.appearance?.allowsVibrancy == true
        for (current, view) in views.enumerated() {
			let active = index == current
			view.textTintColor = active ? textTintColor : textColor
			view.imageTintColor = active ? imageTintColor : textColor
			view.imageIsTemplate = isVibrant && !active
        }
    }
}
