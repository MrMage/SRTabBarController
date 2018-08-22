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
	var topCoverConstraint: NSLayoutConstraint?

    /// Whether or not the tab bar is translucent
    open var translucent = false {
        didSet {
			updateBackground()
        }
    }
    
    /// The background color of the tab bar
    open var backgroundColor = NSColor.black {
		didSet {
			updateBackground()
        }
	}
	
	private func updateBackground() {
		backgroundView.state = translucent ? .active : .inactive
		backgroundView.isHidden = !translucent
		self.layer?.backgroundColor = !translucent ? self.backgroundColor.cgColor : nil
	}
	
	/// The colour used for active items
	open var textTintColor = NSColor.yellow
	open var imageTintColor = NSColor.yellow
	
    /// The colour used for inactive items
    open var textColor = NSColor.white
    
    /// Spacing between the items
    open var itemSpacing: CGFloat = 20 {
        didSet {
            stack?.spacing = itemSpacing
        }
    }
    
    /// The items that are displayed on the tab bar.
    /// When set, the tabs will be added to a stack view.
    open var items = [SRTabItem]() {
        didSet {
			topCoverConstraint = nil
			topCoverView.removeFromSuperview()
			
            stack?.removeFromSuperview()
            stack = NSStackView(views: items.sorted { $0.index < $1.index })
            stack?.spacing = itemSpacing
            backgroundView.addSubview(stack!)
            
            if [SRTabLocation.Top, SRTabLocation.Bottom].contains(location) {
                let centerX = NSLayoutConstraint(item: stack!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
                let centerY = NSLayoutConstraint(item: stack!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
                
                addConstraints([centerX, centerY])
				
				layoutGuideConstraint = nil
            } else {
                stack?.alignment = .centerX
                
                let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stack]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["stack": stack!])
				addConstraints(horizontal)
				
				if let layoutGuide = self.window?.contentLayoutGuide as? NSLayoutGuide {
					layoutGuideConstraint = layoutGuide.topAnchor.constraint(equalTo: stack!.topAnchor, constant: -0.5 * (itemSpacing + 8))
					layoutGuideConstraint?.isActive = true
					
					if !translucent {
						addSubview(topCoverView)
						addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[topCoverView]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["topCoverView": topCoverView]))
						addConstraints(NSLayoutConstraint.constraints(
							withVisualFormat: "V:|-0-[topCoverView]", options: [],
							metrics: nil, views: ["topCoverView": topCoverView]))
						
						topCoverConstraint = layoutGuide.topAnchor.constraint(equalTo: topCoverView.bottomAnchor, constant: 1)
						topCoverConstraint?.isActive = true
					}
				} else {
					let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-44-[stack]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["stack": stack!])
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
    
    public let backgroundView = NSVisualEffectView()
	fileprivate var topCoverView = NSView()

    // MARK: - Methods
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
		
		backgroundView.blendingMode = .behindWindow
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.material = .sidebar
		addSubview(backgroundView)
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": backgroundView]))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": backgroundView]))
		
		topCoverView.translatesAutoresizingMaskIntoConstraints = false
		topCoverView.wantsLayer = true
		topCoverView.layer?.backgroundColor = NSColor(calibratedWhite: 0.94, alpha: 1).cgColor
		
		let shadow = NSShadow()
		shadow.shadowBlurRadius = 1
		shadow.shadowOffset = NSSize(width: 0, height: 0)
		shadow.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.6)
		topCoverView.shadow = shadow
		
		self.wantsLayer = true
		updateBackground()
    }
	
	open override func layout() {
		super.layout()
		
		if #available(OSX 10.14, *),
			self.effectiveAppearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua {
			backgroundView.appearance = NSAppearance(named: .vibrantDark)
		} else {
			backgroundView.appearance = NSAppearance(named: .vibrantLight)
		}
		
		var shadowRect = self.bounds
		if topCoverView.superview != nil {
			shadowRect.size.height -= topCoverView.bounds.height
		}
		self.layer?.shadowPath = CGPath(rect: shadowRect, transform: nil)
	}

    
    /**
     Set the active item on the tab bar
     
     - parameter index: The index to add
     */
    internal func setActive(_ index: Int) {
        guard let views = stack?.views as? [SRTabItem] else {
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
