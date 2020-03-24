//
//  SRTabBarController.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBarController: NSViewController, NSTabViewDelegate, SRTabItemDelegate {
    
    /// The tab bar
    open var tabBar: SRTabBar?
    
    /// The tab view that is being used behind the scenes
    open var tabView: NSTabView?
    
    /// The currently selected tab index
    open var currentIndex = 0
    
    /// The delegate for the controller
    open weak var delegate: SRTabBarDelegate?
    
    /// The location of the tab bar on the screen
    open var tabBarLocation: SRTabLocation = .Left {
        didSet {
            loadViewFromNib()
            tabBar?.location = tabBarLocation
            embedTabs()
        }
    }
    
    /// The background color of the tab bar
    @IBInspectable open var barBackgroundColor: NSColor = NSColor.black {
        didSet {
            tabBar?.backgroundColor = barBackgroundColor
        }
    }
    
    /// The text color of the tab bar 
    @IBInspectable open var barTextColor: NSColor = NSColor.white {
        didSet {
            tabBar?.textColor = barTextColor
        }
	}
	
	/// The tint color of the tab bar's text
	@IBInspectable open var barTextTintColor: NSColor = NSColor.yellow {
		didSet {
			tabBar?.textTintColor = barTextTintColor
		}
	}
	
	/// The tint color of the tab bar's images
	@IBInspectable open var barImageTintColor: NSColor = NSColor.yellow {
		didSet {
			tabBar?.imageTintColor = barImageTintColor
		}
	}
	
    /// The spacing between items on the tab bar
    @IBInspectable open var itemSpacing: CGFloat = 20 {
        didSet {
            tabBar?.itemSpacing = itemSpacing
        }
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        embedTabs()
    }
    
    /**
     Load the view from the NIB
     */
    fileprivate func loadViewFromNib() {
        var nibObjects: NSArray?
        Bundle(for: SRTabBarController.self).loadNibNamed(
			tabBarLocation.rawValue,
			owner: self, topLevelObjects: &nibObjects)
        
        for object in nibObjects ?? [] {
            guard let view = object as? SRTabView else {
                continue
            }
            
            tabBar = view.tabBar
            tabView = view.tabView
            self.view = view
			
			tabBar?.backgroundColor = barBackgroundColor
			tabBar?.textTintColor = barTextTintColor
			tabBar?.imageTintColor = barImageTintColor
            tabBar?.textColor = barTextColor
            tabBar?.itemSpacing = itemSpacing
        }
        
    }
    
    
    /**
     Select the tab item at the specified index
     
     - parameter index: The index to select
     */
    open func selectTabAtIndex(_ index: Int) {
        tabView?.selectTabViewItem(at: index)
    }
    
    
    // MARK: - Load Tabs
    
    /**
     Embed the tabs defined in the storyboard
     */
    fileprivate func embedTabs() {
        // Commented out in the hopes of fixing window state restoration on macOS 10.15.
        /*
        /// MAY get rejected from the MAS
        guard let segues = value(forKey: "segueTemplates") as? [NSObject] else {
            return
        }
        
        for segue in segues {
            if let id = segue.value(forKey: "identifier") as? NSStoryboardSegue.Identifier {
                performSegue(withIdentifier: id,
							 sender: self)
            }
        }
        
        tabBar?.setActive(currentIndex)
        */
    }
    
    // Commented out in the hopes of fixing window state restoration on macOS 10.15.
    /*open override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier else {
            print("Identifier not set")
            return
        }
        
        guard let vc = segue.destinationController as? NSViewController else {
            print("Could not load destination view controller")
            return
        }
        
        let pieces: [String] = id.split(separator: "_").map(String.init)
        
        guard let index = Int(pieces[1]) else {
            print("Could not get index from identifier")
            return
        }
        
        let item = SRTabItem(index: index, viewController: vc)
        if pieces.count > 2 {
            item.image = NSImage(named: pieces[2])
        }
        addTabItem(item)
        
    }*/
    
    /**
     Add a tab item to the NSTabView and the SRTabBar
     
     - parameter item: The tab item to be added
     */
    open func addTabItem(_ item: SRTabItem) {
        
        guard let vc = item.viewController else {
            print("View controller not set on tab item")
            return
        }
        
        let tabItem = NSTabViewItem(viewController: vc)
        tabView?.addTabViewItem(tabItem)
        
        item.delegate = self
        tabBar?.items.append(item)
    }
    
    
    // MARK: - NSTabViewDelegate
    
    open func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        guard let item = tabViewItem else {
            return
        }
        
        currentIndex = tabView.indexOfTabViewItem(item)
        tabBar?.setActive(currentIndex)
        delegate?.tabIndexChanged(currentIndex)
    }
    
    
    // MARK; - SRTabItemDelegate
    
    func tabIndexShouldChangeTo(_ index: Int) {
        tabView?.selectTabViewItem(at: index)
    }
    
}
