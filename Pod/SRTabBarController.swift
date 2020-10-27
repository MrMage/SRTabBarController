//
//  SRTabBarController.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBarController: NSViewController, SRTabItemDelegate {
	private let splitViewController: NSSplitViewController = {
		let controller = NSSplitViewController()
		controller.splitView.identifier = NSUserInterfaceItemIdentifier("SRTabBarController_splitViewController")
		controller.splitView.autosaveName = controller.splitView.identifier.map(\.rawValue)
		return controller
	}()
	private let barController = SRTabBarControllerInternal()
	private lazy var barItem: NSSplitViewItem = {
		let item = NSSplitViewItem(sidebarWithViewController: barController)
		item.canCollapse = false
		item.minimumThickness = 200
		item.maximumThickness = 400
		item.preferredThicknessFraction = NSSplitViewItem.unspecifiedDimension
		return item
	}()
	private var currentMainItem: NSSplitViewItem?

	public var tabBar: SRTabBar { barController.tabBar }

	public var extraViewController: NSViewController? {
		get { barController.extraViewController }
		set { barController.extraViewController = newValue }
	}
    
    /// The delegate for the controller
    open weak var delegate: SRTabBarDelegate?
    
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

		tabBar.textTintColor = barTextTintColor
		tabBar.imageTintColor = barImageTintColor
		tabBar.textColor = barTextColor
    }

    open func selectTabAtIndex(_ index: Int) {
		guard index >= 0, index < tabBar.items.count else {
			return
		}

		let newViewController = tabBar.items[index].viewController
		if newViewController !== currentMainItem?.viewController {
			if let currentMainItem = currentMainItem {
				splitViewController.removeSplitViewItem(currentMainItem)
			}

			let newItem = NSSplitViewItem(viewController: newViewController)
			newItem.canCollapse = false
			if #available(OSX 11.0, *) {
				newItem.titlebarSeparatorStyle = .shadow
			}
			splitViewController.addSplitViewItem(newItem)
			self.currentMainItem = newItem
		}

		tabBar.setActive(index)
		delegate?.tabIndexChanged(index)
    }

	open func setTabItems(_ items: [SRTabItem]) {
		for item in items {
			item.delegate = self
		}
		tabBar.items = items

		if tabBar.items.count >= 1 {
			self.selectTabAtIndex(0)
		}
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
