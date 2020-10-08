//
//  SubState_Translator.swift
//  SubState
//
//  Created by Josh Kneedler on 10/6/20.
//

import Combine
import Poet
import SwiftUI

extension SubStateView {
    
    class Translator {
        typealias Evaluator = SubStateView.Evaluator
        typealias State = Evaluator.State
        
        // Observable values
        // rework to enum
        @Observable var navId: Int = 0
        
        // State Sink
        private var stateSink: AnyCancellable?
        
        init(_ state: Passable<State>) {
            stateSink = state.subject.sink { [weak self] value in
                if let value = value {
                    self?.translate(state: value)
                }
            }
        }
        
    }
}

extension SubStateView.Translator {
    func translate(state: State) {
        
        switch state {
        
        case .listTracks(let state):
            translateListTracksState(state)
            
        case .addLog(let state):
            translateAddLogState(state)
            
        case .listLog(let state):
            translateListLogState(state)

        }
    }
    
    func translateListTracksState(_ state: Evaluator.ListTracksState) {
        debugPrint("translate list tracks")
        navId = 0
    }
    
    func translateAddLogState(_ state: Evaluator.AddLogState) {
        debugPrint("translate add log")
        navId = 1
    }
    
    func translateListLogState(_ state: Evaluator.ListLogState) {
        debugPrint("translate list log")
        navId = 2
    }

}
