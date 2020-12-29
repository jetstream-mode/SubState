//
//  NavSelectionEvaluating.swift
//  SubState
//
//  Created by Josh Kneedler on 11/30/20.
//

import Foundation

enum NavItem {
    case list
    case addLog
    case listLog
}

protocol NavSelectionEvaluating {
    var selectedKey: Int { get set }
    func navItemSelected(_ navItem: NavItem)
}
