//
//  CorridorView.swift
//  CorridorView
//
//  Created by Josh Kneedler on 8/14/20.
//

import SwiftUI

struct CorridorView<Content: View>: View {
    @StateObject var evaluator: Evaluator
    let content: Content

    init(evaluator: Evaluator = .init(), @ViewBuilder content: () -> Content) {
        _evaluator = StateObject(wrappedValue: evaluator)
        self.content = content()
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0) {
                    self.content.frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.evaluator.selectedKey) * geometry.size.width)
                .animation(.default)
            }
        }
    }
}



