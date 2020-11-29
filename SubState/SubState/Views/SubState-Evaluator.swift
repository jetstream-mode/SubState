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
        enum Element: EvaluatorElement {
            case trackList
        }

        
        init() {
            //users = Bundle.main.decode([User].self, from: "users.json")
        }
    }
}

// MARK: - States

extension SubState.Evaluator {
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

