//
//  EvaluatingTextField.swift
//  SimpleEvaluatorTranslatorPatterns
//
//  Created by Stephen E. Cotner on 9/22/20.
//

import Combine
import SwiftUI

struct EvaluatingTextField: View {
    /// To programmatically change the text in the text field, assign a value to `passableText`
    class Model: ObservableObject {
        @Published var placeholder: String
        @Published var elementName: EvaluatorElement
        @Passable var passableText: String? = ""
        
        init(placeholder: String, elementName: EvaluatorElement) {
            self.placeholder = placeholder
            self.elementName = elementName
        }
    }
    
    /// TextModel is used internally by EvaluatingTextField and by its nested view, TextFieldClearButton
    fileprivate class TextModel: ObservableObject {
        let objectDidChange = ObservableObjectPublisher()
        
        @Published var text: String = "" {
            didSet {
                objectDidChange.send()
            }
        }
        
        init() {}
    }
    
    @ObservedObject var model: Model
    private let evaluator: TextFieldEvaluating
    
    @StateObject fileprivate var textModel: TextModel = TextModel()
    
    //var textSink: AnyCancellable?
    
    init(model: Model, evaluator: TextFieldEvaluating) {
        self.evaluator = evaluator
        self.model = model
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 10) {
                    TextField(model.placeholder, text: $textModel.text)
                        .disableAutocorrection(true)
                        .modifier(DisableAutocapitalization())
                        .onReceive(textModel.objectDidChange) {
                            evaluator.textFieldDidChange(text: textModel.text, elementName: model.elementName)
                        }

                    TextFieldClearButton(textModel: _textModel.wrappedValue, passableText: model.$passableText)
                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.primary.opacity(0.05))
                )
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            }
        }
        .padding(.bottom, 10)
        
        .onReceive(model.$passableText.subject) { (string) in
            if let string = string {
                self.textModel.text = string
            }
        }
    }
}

struct TextFieldClearButton: View {
    @ObservedObject fileprivate var textModel: EvaluatingTextField.TextModel
    var passableText: Passable<String>
    
    var body: some View {
        Button(action: {
            self.passableText.wrappedValue = ""
        }) {
            Image(systemName: "multiply.circle.fill")
                .resizable()
                .frame(width: 14, height: 14)
                .opacity((textModel.text.isEmpty) ? 0 : 0.3)
                .foregroundColor(.primary)
        }
    }
}

struct DisableAutocapitalization: ViewModifier {
    @ViewBuilder func body(content: Content) -> some View {
        #if os(iOS)
        content
            .autocapitalization(.none)
        #else
        content
        #endif
    }
}

