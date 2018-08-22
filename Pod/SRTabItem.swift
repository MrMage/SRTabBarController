//
//  SRTabItem.swift
//  Example
//
//  Created by Stephen Radford on 16/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabItem: NSButton {
	open override var allowsVibrancy: Bool { return true }

    /// The delegate for the item
    weak var delegate: SRTabItemDelegate?
    
    /// The index of the item on the bar
    var index = 0
    
    /// The view controller associated with this item
	var viewController: NSViewController?
	
	override open var title: String {
		didSet {
			imagePosition = title.isEmpty ? .imageOnly : .imageAbove
			updateTitle()
		}
	}
	
	var textTintColor: NSColor = NSColor.black {
		didSet { updateTitle() }
	}
	
	var imageTintColor: NSColor = NSColor.black {
		didSet {
			if #available(OSX 10.14, *) {
				self.contentTintColor = imageTintColor
			} else {
				updateImage()
			}
		}
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
		
		self.title = viewController.title ?? ""
        
        (cell as? NSButtonCell)?.highlightsBy = NSCell.StyleMask()
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
    
    @objc func buttonPressed() {
        delegate?.tabIndexShouldChangeTo(index)
    }
	
	func updateTitle() {
		attributedTitle = NSAttributedString(string: title, attributes: [
			.font: NSFont.systemFont(ofSize: 10),
			.foregroundColor: textTintColor
			])
	}
	
	func updateImage() {
		if imageIsTemplate {
			self.image?.isTemplate = true
			super.image = self.image
			return
		}
		
		guard let image = image?.copy() as? NSImage else {
			Swift.print("Item has no image")
			super.image = nil
			return
		}
		
		image.isTemplate = false
		
		image.lockFocus()
		imageTintColor.set()
		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
		imageRect.fill(using: .sourceAtop)
		image.unlockFocus()
		
		super.image = image
	}
}
