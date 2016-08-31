//
//  ViewController.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

class ViewController: SRTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		barTextColor = NSColor.controlTextColor()
		barTextTintColor = NSColor(red: 0.1, green: 0.5, blue: 1, alpha: 1)//.alternateSelectedControlColor()()
		barImageTintColor = NSColor(red: 0.2, green: 0.65, blue: 1, alpha: 1)
		
        tabBarLocation = .Left
		
        tabBar?.translucent = true
        tabBar?.material = .UltraDark
        //tabBar?.material = .Titlebar
        tabBar?.blendingMode = .BehindWindow
		tabBar?.appearance = NSAppearance(named: NSAppearanceNameVibrantDark)
		
		tabBar?.setActive(0)
    }

}

