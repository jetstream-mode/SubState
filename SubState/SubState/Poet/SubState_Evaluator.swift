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
    
    func showListTracksState() {
        
        let state = ListTracksState(
            pageTitle: "List Tracks",
            tracks: [])
        
        self.state = .listTracks(state)
    }
    
    func showAddLogState() {
        
        let state = AddLogState(
            pageTitle: "Add Log",
            tracks: [])
        
        self.state = .addLog(state)
    }
    
    func showListLogState() {
        
        let state = ListLogState(
            pageTitle: "List Log")
        
        self.state = .listLog(state)
    }
    
    
}

// MARK: View Cycle
extension SubStateView.Evaluator: Evaluating, Evaluating_ViewCycle {

        
    enum Action: EvaluatorAction, EvaluatorAction_ViewCycle {
        
        case onAppear
        case onDisappear
        case navSelectTracks
        case navAddLog
        case navListLog
    }
    
    func evaluate(_ action: Action?) {
        switch action {
        case .onAppear:
            debugPrint("on appear sub state!")
        case .onDisappear:
            break
        case .navSelectTracks:
            showListTracksState()
        case .navAddLog:
            showAddLogState()
        case .navListLog:
            showListLogState()
        case .none:
            break
        }
    }
}

