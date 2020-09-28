//
//  ShapeView.swift
//  SubState
//
//  Created by Josh Kneedler on 9/24/20.
//

import SwiftUI

struct ShapeView: Shape {
    let bezier: UIBezierPath
    
    func path(in rect: CGRect) -> Path {
        let path = Path(bezier.cgPath)
        let multiplier = min(rect.width, rect.height)
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        
        return path.applying(transform)
    }
}
