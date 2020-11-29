//
//  SubState-Translator.swift
//  SubState
//
//  Created by Josh Kneedler on 11/25/20.
//

import Combine
import Foundation
import SwiftUI

extension SubState {
    
    class Translator {
        
        typealias Evaluator = SubState.Evaluator
        typealias Element = Evaluator.Element
        typealias State = Evaluator.State
        
        // view models
        
        // State Sink
        var stateSink: AnyCancellable?
        
        init(_ state: Passable<State>) {
            stateSink = state.subject.sink { [weak self] value in
                if let value = value {
                    self?.translate(state: value)
                }
            }
        }
        
        deinit {
            debugPrint("deinit filter translator")
        }
        
    }
}

extension SubState.Translator {
    func translate(state: State) {
        switch state {
        case .listTracks(let state):
            translateListTracks(state)
        case .addLog(let state):
            translateAddLog(state)
        case .listLog(let state):
            translateListLog(state)
        }
    }
    
    func translateListTracks(_ state: Evaluator.ListTracksState) {
        debugPrint("translate list tracks")
    }
    
    func translateAddLog(_ state: Evaluator.AddLogState) {
        debugPrint("translate add log")
    }
    
    func translateListLog(_ state: Evaluator.ListLogState) {
        debugPrint("list log state")
    }
}
