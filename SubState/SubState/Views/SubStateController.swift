//
//  SubStateController.swift
//  SubState
//
//  Created by Josh Kneedler on 12/1/20.
//

import Foundation
import SwiftUI

struct SubStateController: View {
    
    @StateObject var evaluator: Evaluator
        
    let buttonSize: CGFloat = 25
    
    init(evaluator: Evaluator = .init()) {
        _evaluator = StateObject(wrappedValue: evaluator)
    }
    
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

struct SubStateController_Previews: PreviewProvider {
    static var previews: some View {
        let evaluator = Evaluator()
        evaluator.selectedKey = 0
        
        return SubStateController(evaluator: evaluator)
    }
}
