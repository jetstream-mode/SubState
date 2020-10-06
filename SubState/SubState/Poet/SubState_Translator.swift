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
    }
    
    func translateAddLogState(_ state: Evaluator.AddLogState) {
        debugPrint("translate add log")
    }
    
    func translateListLogState(_ state: Evaluator.ListLogState) {
        debugPrint("translate list log")
    }

}
