//
//  SRTabBarControllerInternal.swift
//  SRTabBarController
//
//  Created by Daniel Alm on 22.10.20.
//

import Foundation

open class SRTabBarControllerInternal: NSViewController {
	public var tabBar: SRTabBar { return self.view as! SRTabBar }

	open override func loadView() {
		self.view = SRTabBar(frame: .zero)
	}
}
