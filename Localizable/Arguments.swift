//
//  Arguments.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

class Argument {
    
    func parse() {
        arguments.enumerated().forEach { (item) in
            if item.element.hasPrefix("--") {
                let key = item.element.replacingOccurrences(of: "^--", with: "", options: [.regularExpression], range: item.element.startIndex..<item.element.endIndex)
                switch key {
                case "inputFile":
                    self.inputFile = nextValue(for: item.offset)
                case "outputDirectory":
                    self.outputDirectory = nextValue(for: item.offset)
                case "separator":
                    self.separator = nextValue(for: item.offset)
                default:
                    fatalError("\(key) options not supported")
                }
            }
        }
    }
    
    func nextValue(for index: Int) -> String {
        let nextIndex = index + 1
        guard arguments.indices.contains(nextIndex) else {
            fatalError("value not found for \(arguments[index])")
        }
        return arguments[nextIndex]
    }
    
    private let arguments = CommandLine.arguments
    
    var inputFile: String?
    var outputDirectory: String?
    var separator: String = "_"
}
