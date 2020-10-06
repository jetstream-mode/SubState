//
//  SubState_Evaluator.swift
//  SubState
//
//  Created by Josh Kneedler on 10/6/20.
//

import Poet
import SwiftUI

extension SubStateView {
    
    class Evaluator {
        // Translator
        lazy var translator: Translator = Translator($state)
        
        // Current state
        @Passable var state: State?
        
    }
}

// MARK: State

extension SubStateView.Evaluator {
    
    enum State: EvaluatorState {
        case listTracks(ListTracksState)
        case addLog(AddLogState)
        case listLog(ListLogState)
    }
    
    struct ListTracksState {
        var pageTitle: String
        //maybe
        var tracks: [Tracks]
    }
    
    struct AddLogState {
        var pageTitle: String
        //maybe
        var tracks: [Tracks]
    }
    
    struct ListLogState {
        var pageTitle: String
    }
}

// MARK: View Cycle
extension SubStateView.Evaluator: Evaluating, Evaluating_ViewCycle {

        
    enum Action: EvaluatorAction, EvaluatorAction_ViewCycle {
        case onAppear
        case onDisappear
    }
    
    func evaluate(_ action: Action?) {
        switch action {
        case .onAppear:
            debugPrint("on appear sub state!")
        case .onDisappear:
            break
        case .none:
            break
        }
    }
}

