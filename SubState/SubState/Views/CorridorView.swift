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
/*
struct CorridorNavigation: View {
    @State var evaluator: NavSelectionEvaluating
    //@Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    @Binding var allKeys: [Any]
    let buttonSize: CGFloat = 15
    
    var body: some View {
        
        HStack {
            Spacer()
            Button(action: {
                if slideOpen {
                    slideOpen = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.evaluator.selectedKey -= 1
                        if self.evaluator.selectedKey < 0 {
                            self.evaluator.selectedKey = 0
                        }
                    }
                } else {
                    slideOpen = false
                    evaluator.selectedKey -= 1
                    allKeys.shuffle()
                    if evaluator.selectedKey < 0 {
                        evaluator.selectedKey = 0
                    }
                }
            }) {
                ArrowLeft(parentSize: 12)
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
                .frame(width: 20)
            
            if evaluator.selectedKey == 0 {
                KeyOneRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
                    .transition(.scale)
            } else if evaluator.selectedKey == 1 {
                KeyTwoRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
                    .transition(.scale)
            } else if evaluator.selectedKey == 2 {
                KeyThreeRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
                    .transition(.scale)
            }

            Spacer()
                .frame(width: 30)
            
            Button(action: {
                if slideOpen {
                    slideOpen = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.evaluator.selectedKey += 1
                        if self.evaluator.selectedKey > 11 {
                            self.evaluator.selectedKey = 11
                        }
                    }
                } else {
                    slideOpen = false
                    evaluator.selectedKey += 1
                    allKeys.shuffle()
                    if evaluator.selectedKey > 11 {
                        evaluator.selectedKey = 11
                    }
                }
            }) {
                ArrowRight(parentSize: 12)
                    .foregroundColor(.gray)
                    .frame(width: buttonSize, height: buttonSize)
            }
            .buttonStyle(SquareButtonStyle())
            
            Spacer()
        }
        .animation(.default)
    }
    
}
 */


