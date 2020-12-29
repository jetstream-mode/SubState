//
//  Arrows.swift
//  SubState
//
//  Created by Josh Kneedler on 11/30/20.
//

import Foundation
import SwiftUI

struct ArrowLeft: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ArrowRaw()
                    .frame(width: parentSize, height: parentSize)
                ArrowRaw()
                    .frame(width: parentSize, height: parentSize)
            }
        }
    }
}

struct ArrowRight: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ArrowRaw()
                    .scale(x: -1)
                    .frame(width: parentSize, height: parentSize)
                ArrowRaw()
                    .scale(x: -1)
                    .frame(width: parentSize, height: parentSize)
            }

        }
    }
}

struct ArrowPlay: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            ArrowRaw()
                .scale(x: -1)
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct ArrowPause: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            PauseRaw()
                .frame(width: parentSize, height: parentSize)
                .offset(y: 3)
        }
    }
}
struct ArrowUp: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            ArrowRaw()
                .rotation(.degrees(90))
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct ArrowRaw: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.size.width, y: -(rect.height/2)))
            path.addLine(to: CGPoint(x: -(rect.width/2), y: rect.height/2))
            path.addLine(to: CGPoint(x: rect.size.width, y: rect.height + (rect.height/2)))
            path.closeSubpath()
        }
    }
}

