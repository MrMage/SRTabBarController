//
//  SRTabBarControllerInternal.swift
//  SRTabBarController
//
//  Created by Daniel Alm on 22.10.20.
//

import Foundation

private class TopLayoutGuideAlignedView: NSView {
	var layoutGuideConstraint: NSLayoutConstraint?

	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()

		guard let subview = self.subviews.first,
			  let layoutGuide = self.window?.contentLayoutGuide as? NSLayoutGuide else { return }
		layoutGuideConstraint = layoutGuide.topAnchor.constraint(equalTo: subview.topAnchor, constant: 0)
		layoutGuideConstraint?.isActive = true
	}
}

open class SRTabBarControllerInternal: NSViewController {
	public private(set) lazy var stackView = {
		NSStackView(views: [tabBar])
	}()
	public let tabBar = SRTabBar(frame: .zero)

	private let encloseInScrollView = false

	public var extraViewController: NSViewController? {
		didSet {
			if let oldValue = oldValue {
				oldValue.view.removeFromSuperview()
				oldValue.removeFromParent()
			}

			if let newValue = extraViewController {
				stackView.addArrangedSubview(newValue.view)
				self.addChild(newValue)
			}
		}
	}

	//! FIXME: Handle the `contentLayoutGuide` constraint here.

	open override func loadView() {
		tabBar.translatesAutoresizingMaskIntoConstraints = false

		stackView.orientation = .vertical
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false

		let view = TopLayoutGuideAlignedView()
		view.translatesAutoresizingMaskIntoConstraints = false

		if encloseInScrollView {
			let scrollView = NSScrollView()
			scrollView.translatesAutoresizingMaskIntoConstraints = false
			scrollView.drawsBackground = false
			scrollView.documentView = stackView

			view.addSubview(scrollView)
			view.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "H:|[scrollView]|",
									options: [],
									metrics: nil,
									views: ["scrollView": scrollView]))
			// The top constraint will be provided by `TopLayoutGuideAlignedView`.
			view.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "V:[scrollView]|",
									options: [],
									metrics: nil,
									views: ["scrollView": scrollView]))
		} else {
			view.addSubview(stackView)
			// The top constraint will be provided by `TopLayoutGuideAlignedView`.
			view.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "V:[stackView]|",
									options: [],
									metrics: nil,
									views: ["stackView": stackView]))
		}

		view.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "H:|[stackView]|",
									options: [],
									metrics: nil,
									views: ["stackView": stackView]))

		self.view = view
	}
}
