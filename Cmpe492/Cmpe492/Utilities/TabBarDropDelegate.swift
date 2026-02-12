//
//  TabBarDropDelegate.swift
//  Cmpe492
//
//  Created for Story 3.2 - tab bar hover detection during drag
//

import SwiftUI
import UniformTypeIdentifiers

struct TabBarDropDelegate: DropDelegate {
    let width: CGFloat
    let dragCoordinator: DragCoordinator
    let onSwitchTab: (MainTab) -> Void
    let hoverDelay: TimeInterval
    let targetTabs: [MainTab]
    let tabOrder: [MainTab]

    func dropEntered(info: DropInfo) {
        updateHover(with: info)
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        updateHover(with: info)
        return DropProposal(operation: .move)
    }

    func dropExited(info: DropInfo) {
        dragCoordinator.updateHover(tab: nil)
        dragCoordinator.cancelPendingSwitch()
    }

    func performDrop(info: DropInfo) -> Bool {
        dragCoordinator.updateHover(tab: nil)
        dragCoordinator.cancelPendingSwitch()
        return true
    }

    private func updateHover(with info: DropInfo) {
        guard !targetTabs.isEmpty else {
            dragCoordinator.updateHover(tab: nil)
            dragCoordinator.cancelPendingSwitch()
            return
        }

        let previousTab = dragCoordinator.hoveringTab
        let tab = tabForLocation(info.location)
        if previousTab != tab {
            dragCoordinator.cancelPendingSwitch()
        }
        dragCoordinator.updateHover(tab: tab)

        if let tab, targetTabs.contains(tab) {
            dragCoordinator.scheduleTabSwitch(to: tab, delay: hoverDelay) {
                onSwitchTab(tab)
            }
        } else {
            dragCoordinator.cancelPendingSwitch()
        }
    }

    private func tabForLocation(_ location: CGPoint) -> MainTab? {
        guard width > 0, !tabOrder.isEmpty else { return nil }
        let tabWidth = width / CGFloat(tabOrder.count)
        let index = Int(location.x / tabWidth)
        guard index >= 0, index < tabOrder.count else { return nil }
        return tabOrder[index]
    }
}
