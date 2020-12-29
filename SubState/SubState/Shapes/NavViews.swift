//
//  NavViews.swift
//  SubState
//
//  Created by Josh Kneedler on 11/30/20.
//

import Foundation
import SwiftUI

struct NavBridge: View {
    var parentSize: CGFloat
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct NavCorridor: View {
    var parentSize: CGFloat
    
    var body: some View {
        HStack(spacing: 2) {
            Rectangle()
                .frame(width: parentSize, height: parentSize)
            Rectangle()
                .frame(width: parentSize, height: parentSize)
            Rectangle()
                .frame(width: parentSize, height: parentSize)
        }
    }
}

struct NavLog: View {
    var parentSize: CGFloat
    
    var body: some View {
        ZStack {
            LogRaw()
                .frame(width: parentSize, height: parentSize)
                .offset(y: 8)
        }
    }
}

