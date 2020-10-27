//
//  SRTabBar.swift
//  Example
//
//  Created by Stephen Radford on 15/05/2016.
//  Copyright © 2016 Stephen Radford. All rights reserved.
//

import Cocoa

open class SRTabBar: NSView {
	/// The colour used for active items
	open var textTintColor = NSColor.yellow
	open var imageTintColor = NSColor.yellow
	
    /// The colour used for inactive items
    open var textColor = NSColor.white
    
    /// The items that are displayed on the tab bar.
    /// When set, the tabs will be added to a stack view.
    open var items = [SRTabItem]() {
        didSet {
			tableView.removeFromSuperview()
			tableView.dataSource = self
			tableView.delegate = self
			tableView.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(tableView)
			self.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "H:|[tableView]|",
									options: NSLayoutConstraint.FormatOptions(),
									metrics: nil,
									views: ["tableView": tableView]))
			self.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "V:|[tableView]|",
									options: [],
									metrics: nil,
									views: ["tableView": tableView]))

			tableView.reloadData()
        }
    }
    
    /// The stack view that is added to the bar.
    /// This view contains all of the items.
	fileprivate var tableView: NSTableView = {
		let tableView = NSTableView()
		tableView.selectionHighlightStyle = .sourceList
		tableView.rowSizeStyle = .medium
		tableView.refusesFirstResponder = true

		let onlyColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier("Description"))
		tableView.addTableColumn(onlyColumn)

		return tableView
	}()

    public func setActive(_ index: Int) {
		tableView.selectRowIndexes(.init(integer: index), byExtendingSelection: false)
    }
}

extension SRTabBar: NSTableViewDataSource, NSTableViewDelegate {
	@objc public func numberOfRows(in tableView: NSTableView) -> Int {
		return items.count
	}

	@objc public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard row < items.count else { return nil }
		
		let item = items[row]
		item.imageIsTemplate = true
		
		let cell = NSTableCellView()
		let stackView = NSStackView()
		stackView.spacing = 4
		stackView.orientation = .horizontal
		stackView.translatesAutoresizingMaskIntoConstraints = false
		cell.addSubview(stackView)

		let imageView = NSImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = item.image
		cell.imageView = imageView
		stackView.addArrangedSubview(imageView)
		if #available(OSX 11.0, *) {
			imageView.imageAlignment = .alignCenter
			imageView.imageScaling = .scaleNone
			imageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
			stackView.alignment = .firstBaseline
		} else {
			stackView.alignment = .centerY
			let imageViewMargin: CGFloat = 4
			stackView.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "V:|-(imageViewMargin)-[imageView]-(imageViewMargin)-|", options: [],
									metrics: ["imageViewMargin": imageViewMargin],
									views: ["imageView": imageView]))
			imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
		}
		
		let textField = NSTextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.stringValue = item.title
		textField.allowsExpansionToolTips = true
		textField.lineBreakMode = .byTruncatingMiddle
		textField.isBezeled = false
		textField.drawsBackground = false
		textField.isEditable = false

		cell.textField = textField
		stackView.addArrangedSubview(textField)


		let margin: Double
		if #available(OSX 11.0, *) {
			margin = 0
			cell.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
		} else {
			margin = 16
			// Tweak the image-text alignment.
			imageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor, constant: 1).isActive = true
			cell.addConstraints(NSLayoutConstraint.constraints(
									withVisualFormat: "V:|[stackView]|", options: [],
									metrics: nil,
									views: ["stackView": stackView]))
		}
		cell.addConstraints(NSLayoutConstraint.constraints(
								withVisualFormat: "H:|-(margin)-[stackView]-(margin)-|", options: [],
								metrics: ["margin": margin],
								views: ["stackView": stackView]))

		return cell
	}

	@objc public func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
		if items.isEmpty {
			return .init()
		}

		if let firstIndex = proposedSelectionIndexes.first {
			return .init(integer: firstIndex)
		}
		return .init(integer: 0)
	}

	@objc public func tableViewSelectionDidChange(_ notification: Notification) {
		let selectedRow = tableView.selectedRow
		if selectedRow >= 0 && selectedRow < items.count {
			items[selectedRow].buttonPressed()
		}
	}
}
