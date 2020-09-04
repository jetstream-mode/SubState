//
//  Tracks.swift
//  SubState
//
//  Created by Josh Kneedler on 9/4/20.
//

import Foundation

struct Tracks: Codable, Identifiable {
    let id: String
    let artist: String
    let song: String
    let fileName: String
    let vinylFile: String    
}

