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

struct DoorIdPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.closeSubpath()
        }
    }
}

struct KeyDropPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.closeSubpath()
        }
    }
}

struct RightBackPlateRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 3, y: 140))
            path.addLine(to: CGPoint(x: 3, y: 182))
            path.addLine(to: CGPoint(x: -77, y: (rect.height/2)+22))
            path.addLine(to: CGPoint(x: -77, y: (rect.height/2)+79))
            path.addLine(to: CGPoint(x: 3, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width-25, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width-5, y: rect.height-25))
            path.addLine(to: CGPoint(x: rect.width-5, y: 165))
            path.addLine(to: CGPoint(x: rect.width-25, y: 140))
            path.closeSubpath()
        }
    }
}

struct LeftPlateStripe: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width*0.70, y: 0))
            path.addLine(to: CGPoint(x: rect.width*0.94, y: 17))
            path.addLine(to: CGPoint(x: rect.width*0.98, y: 40))
            path.addLine(to: CGPoint(x: rect.width*0.70, y: 4))
            path.addLine(to: CGPoint(x: 12, y: 10))
            path.closeSubpath()
        }
    }
}

struct RightPlateStripe: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: -9, y: 0))
            path.addLine(to: CGPoint(x: rect.width/2, y: 22))
            path.addLine(to: CGPoint(x: 0, y: 22))
            path.closeSubpath()
        }
    }
}

struct BridgeRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-21)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-21)))
            path.closeSubpath()
        }
    }
}

struct CorridorRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height/2)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: rect.height/2))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.height + (rect.height/2)))
            path.closeSubpath()
        }
    }
}

struct LogRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-3)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-3)))
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-6)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-6)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-9)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-9)))
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-12)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-12)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-15)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-15)))
            path.closeSubpath()
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-18)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: -(rect.height-21)))
            path.addLine(to: CGPoint(x: rect.size.width, y: -(rect.height-21)))
            path.closeSubpath()
        }
    }
}

struct PauseRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: (rect.size.width/2)-4, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)-1, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)-1, y: rect.height))
            path.addLine(to: CGPoint(x: (rect.size.width/2)-4, y: rect.height))
            path.closeSubpath()
            path.move(to: CGPoint(x: (rect.size.width/2)+1, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)+4, y: -(rect.height)))
            path.addLine(to: CGPoint(x: (rect.size.width/2)+4, y: rect.height))
            path.addLine(to: CGPoint(x: (rect.size.width/2)+1, y: rect.height))
            path.closeSubpath()
        }
    }
}



