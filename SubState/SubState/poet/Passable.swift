//
//  Passable.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
class Passable<S> {
    var subject = PassthroughSubject<S?, Never>()
    
    var wrappedValue: S? {
        willSet {
            subject.send(newValue)
        }
    }
    
    var projectedValue: Passable<S> {
        return self
    }

    init(wrappedValue: S?) {
        self.wrappedValue = wrappedValue
    }
}
