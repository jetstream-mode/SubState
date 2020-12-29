//
//  SubState-AppModel.swift
//  SubState
//
//  Created by Josh Kneedler on 12/14/20.
//

import Foundation


class SubStateAppModel: ObservableObject {
    @Published var slideOpen: Bool
    @Published var playPause: Bool
    
    init(slideOpen: Bool, playPause: Bool) {
        self.slideOpen = slideOpen
        self.playPause = playPause
    }
}

