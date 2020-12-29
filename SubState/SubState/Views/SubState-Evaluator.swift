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
    
    class Evaluator: ObservableObject {
        
        // Translator
        lazy var translator: Translator = Translator($state)
        
        // State
        @Passable var state: State?
        
        // Init data
        //let users: [User]?
        //access vars across steps
        var selectedKey: Int = 0
        
        // Elements
        enum Element: EvaluatorElement {
            case navItem
            case trackList
        }

        
        init() {
            //
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
        let navId: Int
        var pageTitle: String
        //maybe
        var tracks: [Tracks]
    }
    
    struct AddLogState {
        let navId: Int
        var pageTitle: String
        //maybe
        var tracks: [Tracks]
    }
    
    struct ListLogState {
        let navId: Int
        var pageTitle: String
    }
    
    func viewDidAppear() {
        if state == nil {
            listTracks()
        }
    }
    
    func listTracks() {
        state = .listTracks(
            ListTracksState(navId: 0, pageTitle: "list tracks", tracks: [])
        )
    }
    
    func addLog() {
        state = .addLog(
            AddLogState(navId: 1, pageTitle: "add log", tracks: [])
        )
    }
    
    func listLog() {
        state = .listLog(
            ListLogState(navId: 2, pageTitle: "list log")
        )
    }
}

extension SubState.Evaluator: NavSelectionEvaluating {
    func navItemSelected(_ navItem: NavItem) {
        switch navItem {
        case .list:
            listTracks()
        case .addLog:
            addLog()
        case .listLog:
            listLog()
        }
    }
}

