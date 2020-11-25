//
//  CorridorView.swift
//  CorridorView
//
//  Created by Josh Kneedler on 8/14/20.
//

import SwiftUI

struct CorridorView<Content: View>: View {
    @Binding var currentIndex: Int
    let content: Content

    init(currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    self.content.frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
                .animation(.default)
            }
        }
    }
    
    
}


