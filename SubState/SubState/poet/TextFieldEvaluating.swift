//
//  TextFieldEvaluating.swift
//  filteringList
//
//  Created by Josh Kneedler on 10/28/20.
//

import Foundation

protocol TextFieldEvaluating {
    func textFieldDidChange(text: String, elementName: EvaluatorElement)
}
