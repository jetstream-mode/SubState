//
//  StateNavigation.swift
//  SubState
//
//  Created by Josh Kneedler on 10/7/20.
//


import SwiftUI


struct StateNavigation: View {
    
    @StateObject var evaluator: Evaluator
    @State var logDisplayItems: [LogEntryData] = []

    let buttonSize: CGFloat = 25
    
    init(evaluator: Evaluator = .init()) {
        _evaluator = StateObject(wrappedValue: evaluator)
    }
            
    var body: some View {
        VStack(alignment: .leading) {

            HStack(alignment: .top) {
                Button(action: {
                    evaluator.navId = 0
                }) {
                    NavBridge(parentSize: 12)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    evaluator.navId = 1
                }) {
                    NavCorridor(parentSize: 8)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                VStack {
                    Button(action: {
                        evaluator.navId = 2
                    }) {
                        NavLog(parentSize: 12)
                            .foregroundColor(.gray)
                            .frame(width: buttonSize, height: buttonSize)
                    }
                    .buttonStyle(SquareButtonStyle())
                    Text("\(logDisplayItems.count)")
                        .font(.custom("DIN Condensed Bold", size: 12))
                        .foregroundColor(Color.gray)
                }
                .onAppear {
                    logDisplayItems = evaluator.logEntries.displayItems()
                }

                Spacer()
                Button(action: {
                    if evaluator.slideOpen {
                        evaluator.slideOpen = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.evaluator.selectedKey -= 1
                            if self.evaluator.selectedKey < 0 {
                                self.evaluator.selectedKey = 0
                            }
                        }
                    } else {
                        evaluator.slideOpen = false
                        evaluator.selectedKey -= 1
                        if evaluator.selectedKey < 0 {
                            evaluator.selectedKey = 0
                        }
                    }
                }) {
                    ArrowLeft(parentSize: 6)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    evaluator.playPause.toggle()
                }) {
                    if evaluator.playPause {
                        ArrowPause(parentSize: 8)
                            .foregroundColor(.gray)
                            .frame(width: buttonSize, height: buttonSize)
                    } else {
                        ArrowPlay(parentSize: 8)
                            .foregroundColor(.gray)
                            .frame(width: buttonSize, height: buttonSize)
                    }

                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    if evaluator.slideOpen {
                        evaluator.slideOpen = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.evaluator.selectedKey += 1
                            if self.evaluator.selectedKey > 11 {
                                self.evaluator.selectedKey = 11
                            }
                        }
                    } else {
                        evaluator.slideOpen = false
                        evaluator.selectedKey += 1
                        if evaluator.selectedKey > 11 {
                            evaluator.selectedKey = 11
                        }
                    }
                }) {
                    ArrowRight(parentSize: 6)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Spacer()
                    .frame(width: 20)
            }
        }
        .offset(x: 5)
    }
    
}








