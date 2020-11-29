//
//  StateNavigation.swift
//  SubState
//
//  Created by Josh Kneedler on 10/7/20.
//

import Poet
import SwiftUI

extension SubState {
    struct StateNavigation<E: Evaluator>: View {
        
        let evaluator: E
        
        @ObservedObject var logEntries = LogEntries()
        //@Binding var navigationState: Int
        @Binding var slideOpen: Bool
        @Binding var selectedKey: Int
        @Binding var playPause: Bool
        let buttonSize: CGFloat = 25
        
        var body: some View {
            VStack(alignment: .leading) {

                HStack(alignment: .top) {
                    Button(action: {
                        evaluator.listTracks()
                    }) {
                        NavBridge(parentSize: 12)
                            .foregroundColor(.gray)
                            .frame(width: buttonSize, height: buttonSize)
                    }
                    .buttonStyle(SquareButtonStyle())
                    Button(action: {
                        evaluator.addLog()
                    }) {
                        NavCorridor(parentSize: 8)
                            .foregroundColor(.gray)
                            .frame(width: buttonSize, height: buttonSize)
                    }
                    .buttonStyle(SquareButtonStyle())
                    VStack {
                        Button(action: {
                            evaluator.listLog()
                        }) {
                            NavLog(parentSize: 12)
                                .foregroundColor(.gray)
                                .frame(width: buttonSize, height: buttonSize)
                        }
                        .buttonStyle(SquareButtonStyle())
                        Text("\(logEntries.displayItems().count)")
                            .font(.custom("DIN Condensed Bold", size: 12))
                            .foregroundColor(Color.gray)
                    }

                    Spacer()
                    Button(action: {
                        if slideOpen {
                            slideOpen = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                selectedKey -= 1
                                if selectedKey < 0 {
                                    selectedKey = 0
                                }
                            }
                        } else {
                            slideOpen = false
                            selectedKey -= 1
                            if selectedKey < 0 {
                                selectedKey = 0
                            }
                        }
                    }) {
                        ArrowLeft(parentSize: 6)
                            .foregroundColor(.gray)
                            .frame(width: buttonSize, height: buttonSize)
                    }
                    .buttonStyle(SquareButtonStyle())
                    Button(action: {
                        playPause.toggle()
                    }) {
                        if playPause {
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
                        if slideOpen {
                            slideOpen = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                selectedKey += 1
                                if selectedKey > 11 {
                                    selectedKey = 11
                                }
                            }
                        } else {
                            slideOpen = false
                            selectedKey += 1
                            //allKeys.shuffle()
                            if selectedKey > 11 {
                                selectedKey = 11
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
}




