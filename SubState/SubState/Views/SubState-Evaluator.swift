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

class Evaluator: ObservableObject {
    
    @DataLoader("tracks.json") var tracks: [Tracks]
    @StateObject var logEntries = LogEntries()
    
    @Published var navId = UserDefaults.standard.integer(forKey: "navId")
    @Published var selectedKey: Int = UserDefaults.standard.integer(forKey: "savedkey")
    @Published var slideOpen: Bool = false
    @Published var playPause: Bool = UserDefaults.standard.bool(forKey: "playpause")
    @Published var playerTime: TimeInterval = UserDefaults.standard.double(forKey: "atsatime")
    @Published var keyDragId: Int = 0
    
    // reference to all the key/song shapes. not currently being used.
    var allKeys: [Any] = [KeyOne.self, KeyTwo.self, KeyThree.self, KeyFour.self, KeyFive.self, KeySix.self, KeySeven.self, KeyEight.self, KeyNine.self, KeyTen.self, KeyEleven.self, KeyTwelve.self]
    
    
    init() {
        debugPrint("eval")
    }
}

