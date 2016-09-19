//
//  SRTabItem.swift
//  Example
//
//  Created by Stephen Radford on 16/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabItem: NSButton {

    /// The delegate for the item
    weak var delegate: SRTabItemDelegate?
    
    /// The index of the item on the bar
    var index = 0
    
    /// The view controller associated with this item
    var viewController: NSViewController?
	
	var textTintColor: NSColor = NSColor.black {
		didSet { updateTitle() }
	}
	
	var imageTintColor: NSColor = NSColor.black {
		didSet { updateImage() }
	}
	
	override open var image: NSImage? {
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
        isBordered = false
        imagePosition = .imageAbove
		focusRingType = .none
        setButtonType(.momentaryChange)
        
        if let title = viewController.title {
            attributedTitle = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: NSFont.systemFont(ofSize: 10),
                NSForegroundColorAttributeName: NSColor.white
            ])
        } else {
            title = ""
            imagePosition = .imageOnly
        }
        
        (cell as? NSButtonCell)?.highlightsBy = NSCellStyleMask()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidMoveToSuperview() {
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
			NSFontAttributeName: NSFont.systemFont(ofSize: 10),
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
		NSRectFillUsingOperation(imageRect, .sourceAtop)
		image.unlockFocus()
		
		image.isTemplate = imageIsTemplate
		
		super.image = image
	}
}
