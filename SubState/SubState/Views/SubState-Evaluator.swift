//
//  SubState-Evaluator.swift
//  SubState
//
//  Created by Josh Kneedler on 11/25/20.
//

import Combine
import Foundation
import SwiftUI

struct SubState {}

extension SubState {
    
    class Evaluator {
        
        // Translator
        lazy var translator: Translator = Translator($state)
        
        // State
        @Passable var state: State?
        
        // Init data
        //let users: [User]?
        
        // Elements
        /*
        enum Element: EvaluatorElement {
            case filterList
        }
 */
        
        init() {
            //users = Bundle.main.decode([User].self, from: "users.json")
        }
    }
}

// MARK: - States

extension SubState.Evaluator {
    enum State: EvaluatorState {
        case notStarted(NotStartedState)
        case filtering(FilteringState)
    }
    
    struct NotStartedState {
        var buttonText: String
    }

    struct FilteringState {
        var backButtonText: String
        var daisyButtonText: String
        var resetButtonText: String
        var userData: [User]
    }
}

extension SubState.Evaluator: TextFieldEvaluating {
    func viewDidAppear() {
        if state == nil {
            notStarted()
        }
    }
    
    func notStarted() {
        state = .notStarted(
            NotStartedState(
                buttonText: "Filter Now"
            )
        )
    }
    
    func start() {

        guard let users = users else {
            return
        }

        state = .filtering(
            FilteringState(
                backButtonText: "Back",
                daisyButtonText: "Daisy",
                resetButtonText: "Reset",
                userData: users
                )
        )
    }
    
    // pass through tests
    func filterDaisy() {
        translator.filterDaisy()
    }
    
    func resetText() {
        translator.resetText()
    }
    
    func textFieldDidChange(text: String, elementName: EvaluatorElement) {
        debugPrint("hey evaluator from text field ", text)
    }
}
