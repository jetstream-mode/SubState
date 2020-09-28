//
//  MiscShapes.swift
//  SubState
//
//  Created by Josh Kneedler on 9/1/20.
//

import SwiftUI

struct LetterB: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width/2, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.size.width/2))
            path.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.width/2))
            path.move(to: CGPoint(x: 0, y: rect.size.width/2))
            path.addLine(to: CGPoint(x: 0, y: rect.size.width))
            path.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.width))
            path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width*(3/4)), radius: rect.size.width/4, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
            path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/4), radius: rect.size.width/4, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        }
    }
}

struct RainDrop: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width/2, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: rect.size.height), control: CGPoint(x: rect.size.width, y: rect.size.height))
            path.addQuadCurve(to: CGPoint(x: rect.size.width/2, y: 0), control: CGPoint(x: 0, y: rect.size.height))
            
        }
    }
}


struct Wave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double
    
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth
        
        let waveLength = width / frequency
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / waveLength
            
            let distanceFromMidWidth = x - midWidth
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            
            //sm in middle
            //let parabola = normalDistance
            let parabola = -(normalDistance * normalDistance) + 1
            
            //where we are up and down on wave
            let sine = sin(relativeX + phase)
            let y = parabola * strength * sine + midHeight
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return Path(path.cgPath)
    }
}



