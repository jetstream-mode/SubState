//
//  Evaluating+Breadcrumbing.swift
//  Poet Tutorial
//
//  Created by Stephen E. Cotner on 7/13/20.
//

import Foundation
import Poet

extension Evaluating {
    func breadcrumb(_ action: Action?) {
        if let action = action {
            debugPrint("Breadcrumb. Evaluator: \(self). Action: \(action.breadcrumbDescription).")
        }
    }
}
