//
//  SRTabBarController.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBarController: NSViewController, SRTabItemDelegate {
	private let splitViewController = NSSplitViewController()
	private let barController = SRTabBarControllerInternal()
	private lazy var barItem: NSSplitViewItem = {
		let item = NSSplitViewItem(sidebarWithViewController: barController)
		item.canCollapse = false
		item.minimumThickness = 78
		item.maximumThickness = 78
		return item
	}()
	private var currentMainItem: NSSplitViewItem?

	public var tabBar: SRTabBar { barController.tabBar }
    
    /// The currently selected tab index
    open var currentIndex = 0
    
    /// The delegate for the controller
    open weak var delegate: SRTabBarDelegate?
    
    /// The background color of the tab bar
    @IBInspectable open var barBackgroundColor: NSColor = NSColor.black {
        didSet {
			tabBar.backgroundColor = barBackgroundColor
        }
    }
    
    /// The text color of the tab bar 
    @IBInspectable open var barTextColor: NSColor = NSColor.white {
        didSet {
			tabBar.textColor = barTextColor
        }
	}
	
	/// The tint color of the tab bar's text
	@IBInspectable open var barTextTintColor: NSColor = NSColor.yellow {
		didSet {
			tabBar.textTintColor = barTextTintColor
		}
	}
	
	/// The tint color of the tab bar's images
	@IBInspectable open var barImageTintColor: NSColor = NSColor.yellow {
		didSet {
			tabBar.imageTintColor = barImageTintColor
		}
	}
	
    /// The spacing between items on the tab bar
    @IBInspectable open var itemSpacing: CGFloat = 20 {
        didSet {
			tabBar.itemSpacing = itemSpacing
        }
    }

	open override func loadView() {
		splitViewController.addSplitViewItem(barItem)

		let view = NSView()
		splitViewController.view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(splitViewController.view)
		view.addConstraints(NSLayoutConstraint.constraints(
								withVisualFormat: "H:|[splitView]|",
								options: [],
								metrics: nil,
								views: ["splitView": splitViewController.view]))
		view.addConstraints(NSLayoutConstraint.constraints(
								withVisualFormat: "V:|[splitView]|",
								options: [],
								metrics: nil,
								views: ["splitView": splitViewController.view]))
		self.view = view

		self.addChild(splitViewController)
	}
    
    open override func viewDidLoad() {
        super.viewDidLoad()

		tabBar.backgroundColor = barBackgroundColor
		tabBar.textTintColor = barTextTintColor
		tabBar.imageTintColor = barImageTintColor
		tabBar.textColor = barTextColor
		tabBar.itemSpacing = itemSpacing
    }

    open func selectTabAtIndex(_ index: Int) {
		guard index >= 0, index < tabBar.items.count else {
			return
		}

		currentIndex = index

		let newViewController = tabBar.items[index].viewController
		if newViewController !== currentMainItem?.viewController {
			if let currentMainItem = currentMainItem {
				splitViewController.removeSplitViewItem(currentMainItem)
			}
			
			let newItem = NSSplitViewItem(viewController: newViewController)
			newItem.canCollapse = false
			newItem.minimumThickness = 100
			splitViewController.addSplitViewItem(newItem)
			self.currentMainItem = newItem
		}

		tabBar.setActive(currentIndex)
		delegate?.tabIndexChanged(currentIndex)
    }

    open func addTabItem(_ item: SRTabItem) {
        item.delegate = self
		tabBar.items.append(item)

		if tabBar.items.count == 1 {
			self.selectTabAtIndex(0)
		}
    }

    // MARK; - SRTabItemDelegate
    
    func tabIndexShouldChangeTo(_ index: Int) {
		self.selectTabAtIndex(index)
    }
}
