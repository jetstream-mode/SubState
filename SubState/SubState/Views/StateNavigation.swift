//
//  StateNavigation.swift
//  SubState
//
//  Created by Josh Kneedler on 10/7/20.
//


import SwiftUI


struct StateNavigation: View {
    
    @State var evaluator: NavSelectionEvaluating
    //need an appModel here
    //@ObservedObject var model = SubStateAppModel()
    @State var model: SubStateAppModel
    
    @ObservedObject var logEntries = LogEntries()
    //@Binding var navigationState: Int
    //@Binding var slideOpen: Bool
    //@Binding var selectedKey: Int
    //@Binding var playPause: Bool
    let buttonSize: CGFloat = 25
            
    var body: some View {
        VStack(alignment: .leading) {

            HStack(alignment: .top) {
                Button(action: {
                    evaluator.navItemSelected(.list)
                }) {
                    NavBridge(parentSize: 12)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                Button(action: {
                    evaluator.navItemSelected(.addLog)
                }) {
                    NavCorridor(parentSize: 8)
                        .foregroundColor(.gray)
                        .frame(width: buttonSize, height: buttonSize)
                }
                .buttonStyle(SquareButtonStyle())
                VStack {
                    Button(action: {
                        self.evaluator.navItemSelected(.listLog)
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
                    if model.slideOpen {
                        model.slideOpen = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.evaluator.selectedKey -= 1
                            if self.evaluator.selectedKey < 0 {
                                self.evaluator.selectedKey = 0
                            }
                        }
                    } else {
                        model.slideOpen = false
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
                    self.model.playPause.toggle()
                }) {
                    if model.playPause {
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
                    if model.slideOpen {
                        model.slideOpen = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.evaluator.selectedKey += 1
                            if self.evaluator.selectedKey > 11 {
                                self.evaluator.selectedKey = 11
                            }
                        }
                    } else {
                        model.slideOpen = false
                        evaluator.selectedKey += 1
                        //allKeys.shuffle()
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








