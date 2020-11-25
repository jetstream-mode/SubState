//
//  KeyShapes.swift
//  keyGrid
//
//  Created by Josh Kneedler on 8/25/20.
//

import SwiftUI

struct KeyOne: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyOneRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
    // not used. use for reference
    func animateKey() {
        withAnimation(self.animation, {
            self.controlAX = self.parentSize * 0.75
            self.controlAY = self.parentSize * 0.75
            self.controlBX = -(self.parentSize/2)
            self.controlBY = -(self.parentSize/2)
        })
    }
}

struct KeyTwo: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyTwoRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyThree: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyFour: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyFive: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeySix: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeySeven: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyEight: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyNine: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyTen: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyEleven: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private var animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyTwelve: View {
    @State private var controlAX: CGFloat = 0
    @State private var controlAY: CGFloat = 0
    @State private var controlBX: CGFloat = 0
    @State private var controlBY: CGFloat = 0
    var parentSize: CGFloat
    
    private let animation: Animation
    
    init(parentSize: CGFloat) {
        self.parentSize = parentSize
        self.animation = Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        ZStack {
            KeyThreeRaw(controlAX: controlAX, controlAY: controlAY, controlBX: controlBX, controlBY: controlBY)
        }
    }
}

struct KeyOneRaw: Shape {
    
    var controlAX: CGFloat = 0
    var controlAY: CGFloat = 0
    var controlBX: CGFloat = 0
    var controlBY: CGFloat = 0

    public var animatableData: AnimatablePair<AnimatablePair<Double, Double>, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(AnimatablePair(Double(controlAX), Double(controlAY)), AnimatablePair(Double(controlBX), Double(controlBY)))
        }
        set {
            self.controlAX = CGFloat(newValue.first.first)
            self.controlAY = CGFloat(newValue.first.second)
            self.controlBX = CGFloat(newValue.second.first)
            self.controlBY = CGFloat(newValue.second.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width/4, y: -(rect.height/2)))
            path.addQuadCurve(to: CGPoint(x: (rect.size.width*0.20), y: rect.size.height+(rect.height/2)), control: CGPoint(x: (rect.size.width/2)+controlAX, y: (rect.size.height/2)+controlAY))
            path.addQuadCurve(to: CGPoint(x: rect.size.width+(rect.width/2), y: rect.size.height*0.25), control: CGPoint(x: rect.size.width+controlBX, y: rect.size.height+controlBY))
            path.addQuadCurve(to: CGPoint(x: rect.size.width*0.25, y: -(rect.height/2)), control: CGPoint(x: rect.size.width/2, y: rect.size.height/2))
            path.closeSubpath()
        }
    }
}

extension UIBezierPath {
    static var keyOneBezier: UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0.2, y: 0.2))
        path.addCurve(to: CGPoint(x: 0.8, y: 0.4), controlPoint1: CGPoint(x: 0.534, y: 0.5816), controlPoint2: CGPoint(x: 0.2529, y: 0.4205))

        
        return path
    }
}

struct KeyTwoRaw: Shape {
    
    var controlAX: CGFloat = 0
    var controlAY: CGFloat = 0
    var controlBX: CGFloat = 0
    var controlBY: CGFloat = 0

    public var animatableData: AnimatablePair<AnimatablePair<Double, Double>, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(AnimatablePair(Double(controlAX), Double(controlAY)), AnimatablePair(Double(controlBX), Double(controlBY)))
        }
        set {
            self.controlAX = CGFloat(newValue.first.first)
            self.controlAY = CGFloat(newValue.first.second)
            self.controlBX = CGFloat(newValue.second.first)
            self.controlBY = CGFloat(newValue.second.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: -(rect.width/2), y: (rect.height/2)))
            path.addQuadCurve(to: CGPoint(x: rect.width+(rect.width/2), y: (rect.height/2)), control: CGPoint(x: rect.width/2, y: (rect.height/2)+controlAY))
            path.addLine(to: CGPoint(x: rect.width+(rect.width/2), y: (rect.height/2)+(rect.height*0.40)))
            path.addQuadCurve(to: CGPoint(x: -(rect.width/2), y: (rect.height/2)+(rect.height*0.40)), control: CGPoint(x: rect.width/2, y: (rect.height/2)+(rect.height*0.40)+controlBY))
            path.closeSubpath()
        }
    }
}

struct KeyThreeRaw: Shape {
    
    var controlAX: CGFloat = 0
    var controlAY: CGFloat = 0
    var controlBX: CGFloat = 0
    var controlBY: CGFloat = 0

    public var animatableData: AnimatablePair<AnimatablePair<Double, Double>, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(AnimatablePair(Double(controlAX), Double(controlAY)), AnimatablePair(Double(controlBX), Double(controlBY)))
        }
        set {
            self.controlAX = CGFloat(newValue.first.first)
            self.controlAY = CGFloat(newValue.first.second)
            self.controlBX = CGFloat(newValue.second.first)
            self.controlBY = CGFloat(newValue.second.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: -(rect.width/2), y: rect.height + (rect.height/2)))
            path.addQuadCurve(to: CGPoint(x: rect.width+(rect.width/2), y: -(rect.height/2)), control: CGPoint(x: (rect.width/2)+controlAX, y: (rect.width/2)+controlAY))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height+(rect.height/2)))

            path.closeSubpath()
        }
    }
}
