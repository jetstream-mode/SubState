//
//  FilteringList.swift
//  
//
//  Created by Josh Kneedler on 10/19/20.
//
import Combine
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}

class FilterListModel<T>: ObservableObject {
    @Published var elementName: EvaluatorElement
    @Published var filterKeyPaths: [KeyPath<T, String>]
    @Passable var passableText: String? = ""
    
    init(elementName: EvaluatorElement, filterKeyPaths: [KeyPath<T, String>]) {
        self.elementName = elementName
        self.filterKeyPaths = filterKeyPaths
    }
}


struct FilteringList<T: Identifiable, Content: View>: View {
    
    // TextModel to report text to evaluator
    fileprivate class TextModel: ObservableObject {
        let objectDidChange = ObservableObjectPublisher()
        
        @Published var text: String = "" {
            didSet {
                objectDidChange.send()
            }
        }
        
        init() {}
    }
    
    @ObservedObject var model: FilterListModel<T>

    private let evaluator: TextFieldEvaluating
    
    @StateObject fileprivate var textModel: TextModel = TextModel()
    
    @State private var filteredItems = [T]()
    @State private var filterString = ""
    
    let listItems: [T]
    let content: (T) -> Content
    

    init(_ data: [T], evaluator: TextFieldEvaluating, model: FilterListModel<T>, @ViewBuilder rowContent: @escaping (T) -> Content) {
        listItems = data
        self.evaluator = evaluator
        self.model = model
        content = rowContent
    }
    
    var body: some View {
        VStack {
            TextField("Type to filter", text: $textModel.text.onChange(applyFilter))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onReceive(textModel.objectDidChange) {
                    evaluator.textFieldDidChange(text: textModel.text, elementName: model.elementName)
                }
            List(filteredItems, rowContent: content)
                .onAppear(perform: applyFilter)
                
        }
        .onReceive(model.$passableText.subject) { (string) in
            if let string = string {
                self.textModel.text = string
                applyFilter()
            }
        }
    }

    
    func applyFilter() {
        let cleanedFilter = textModel.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedFilter.isEmpty {
            filteredItems = listItems
        } else {
            filteredItems = listItems.filter { element in
                model.filterKeyPaths.contains {
                    element[keyPath: $0]
                        .localizedCaseInsensitiveContains(cleanedFilter)
                }
            }

        }
    }
    
}


