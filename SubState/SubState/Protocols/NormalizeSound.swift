//
//  NormalizeSound.swift
//  SubState
//
//  Created by Josh Kneedler on 9/10/20.
//

import Foundation
import UIKit

protocol NormalizeSound {
    func normalizeSoundLevel(level: Float, height: CGFloat) -> CGFloat
}

extension NormalizeSound {
    func normalizeSoundLevel(level: Float, height: CGFloat = 1000) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 25) / 2 // between 0.1 and 25
        
        return CGFloat(level * (height / 25)) // scaled to max at 300 (our height of our bar)
    }
}
