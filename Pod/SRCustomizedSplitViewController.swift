//
//  SRCustomizedSplitViewController.swift
//  SRTabBarController
//
//  Created by Daniel Alm on 22.10.20.
//

import Foundation

final class SRCustomizedSplitViewController: NSSplitViewController {
	override func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
		true
	}

	override func splitView(_ splitView: NSSplitView, effectiveRect proposedEffectiveRect: NSRect, forDrawnRect drawnRect: NSRect, ofDividerAt dividerIndex: Int) -> NSRect {
		// Disables the "resize" cursor on the split view.
		NSRect.zero
	}
}
