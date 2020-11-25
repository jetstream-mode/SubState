//
//  Hideable.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/23/20.
//

import SwiftUI

/**
 Set removesContent to false to allow a view to maintain its full size as it fades away.
 In most cases, you'll want removesContent to be true.
 */
class HideableModel: ObservableObject {
    @Published var isShowing: Bool
    @Published var removesContent: Bool
    @Published var transition: AnyTransition?
    
    init(isShowing: Bool, removesContent: Bool, transition: AnyTransition?) {
        self.isShowing = isShowing
        self.removesContent = removesContent
        self.transition = transition
    }
}

struct Hideable<Content>: View where Content : View {
    typealias Model = HideableModel
    
    @ObservedObject var model: Model
    var content: () -> Content
    
    init(model: Model, @ViewBuilder content: @escaping () -> Content) {
        self.model = model
        self.content = content
    }
    
    var body: some View {
        if model.removesContent {
            if model.isShowing {
                if model.transition != nil {
                    content()
                        .transition(model.transition!)
                } else {
                    content()
                }
            }
        } else {
            if model.transition != nil {
                content()
                    .opacity(model.isShowing ? 1 : 0)
                    .transition(model.transition!)
            } else {
                content()
                    .opacity(model.isShowing ? 1 : 0)
            }
        }
    }
}
