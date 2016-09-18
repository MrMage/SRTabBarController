//
//  SRTabItem.swift
//  Example
//
//  Created by Stephen Radford on 16/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

public class SRTabItem: NSButton {

    /// The delegate for the item
    weak var delegate: SRTabItemDelegate?
    
    /// The index of the item on the bar
    var index = 0
    
    /// The view controller associated with this item
    var viewController: NSViewController?
	
	var textTintColor: NSColor = NSColor.blackColor() {
		didSet { updateTitle() }
	}
	
	var imageTintColor: NSColor = NSColor.blackColor() {
		didSet { updateImage() }
	}
	
	override public var image: NSImage? {
		didSet { updateImage() }
	}
	
	var imageIsTemplate: Bool = false {
		didSet { updateImage() }
	}
    
    // MARK: - Initializers
    
    init(index: Int, viewController: NSViewController) {
        super.init(frame: NSZeroRect)
        
        self.index = index
        self.viewController = viewController
        wantsLayer = true
        bordered = false
        imagePosition = .ImageAbove
		focusRingType = .None
        setButtonType(.MomentaryChangeButton)
        
        if let title = viewController.title {
            attributedTitle = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: NSFont.systemFontOfSize(10),
                NSForegroundColorAttributeName: NSColor.whiteColor()
            ])
        } else {
            title = ""
            imagePosition = .ImageOnly
        }
        
        (cell as? NSButtonCell)?.highlightsBy = .NoCellMask
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        
        target = self
        action = #selector(buttonPressed)
    }
    
    // MARK: - Actions
    
    func buttonPressed() {
        delegate?.tabIndexShouldChangeTo(index)
    }
	
	func updateTitle() {
		attributedTitle = NSAttributedString(string: title, attributes: [
			NSFontAttributeName: NSFont.systemFontOfSize(10),
			NSForegroundColorAttributeName: textTintColor
			])
	}
	
	func updateImage() {
		guard let image = image?.copy() as? NSImage else {
			Swift.print("Item has no image")
			return
		}
		
		image.lockFocus()
		imageTintColor.set()
		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
		NSRectFillUsingOperation(imageRect, .CompositeSourceAtop)
		image.unlockFocus()
		
		image.template = imageIsTemplate
		
		super.image = image
	}
}
