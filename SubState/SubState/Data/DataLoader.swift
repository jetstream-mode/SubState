//
//  DataLoader.swift
//  SubState
//
//  Created by Josh Kneedler on 9/17/20.
//

import Foundation
import SwiftUI

@propertyWrapper
struct DataLoader<T> where T: Decodable {
    private let fileName: String

    var wrappedValue: T {
        get {
            guard let result = loadJson(fileName: fileName) else {
                fatalError("Cannot load json data \(fileName)")
            }
            return result
        }
        
        nonmutating set {

        }


    }
    
    //public var projectedValue: T { return wrappedValue }
    /*
    public var projectedValue: Binding<T> {
        return Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
 */

    init(_ fileName: String) {
        self.fileName = fileName
    }

    func loadJson(fileName: String) -> T? {
        return Bundle.main.decode(T.self, from: fileName)
    }
    
    //public var projectedValue: Binding<T>
}
