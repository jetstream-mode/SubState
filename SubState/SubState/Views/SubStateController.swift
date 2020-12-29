//
//  SubStateController.swift
//  SubState
//
//  Created by Josh Kneedler on 12/1/20.
//

import Foundation
import SwiftUI

struct SubStateController: View {
    @State var evaluator: NavSelectionEvaluating
    
    //@Binding var selectedKey: Int
    @Binding var slideOpen: Bool
    @Binding var allKeys: [Any]
    
    let buttonSize: CGFloat = 25
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            Image("subStateLogo")
            
            if evaluator.selectedKey == 0 {
                KeyOneRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize/2, height: buttonSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .offset(x: 10)
                    .transition(.scale)
            } else if evaluator.selectedKey == 1 {
                KeyTwoRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize/2, height: buttonSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .offset(x: 10)
                    .transition(.scale)
            } else if evaluator.selectedKey == 2 {
                KeyThreeRaw()
                    .foregroundColor(.gray)
                    .frame(width: buttonSize/2, height: buttonSize/2)
                    .alignmentGuide(.bottom) { d in
                        d[.bottom] + 20
                    }
                    .offset(x: 10)
                    .transition(.scale)
            }

        }
        .offset(x: 5)
        .animation(.default)

    }
    
}
