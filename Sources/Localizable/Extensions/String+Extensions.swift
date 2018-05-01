//
//  String+Extensions.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

extension String {
    
    /// convert to case key
    /// e.g.) test.fuga_hoge => FugeHoge
    ///
    /// - Parameter separator: String
    /// - Returns: String
    func convertToCaseKey(with separator: String) -> String {
        let components = self.components(separatedBy: separator).dropFirst()
        return components.map { component -> String in
            let secondIndex = component.index(component.startIndex, offsetBy: 1)
            let firstChar = String(component[component.startIndex..<secondIndex])
            return component.replacingCharacters(in: component.startIndex..<secondIndex, with: firstChar.uppercased())
        }.joined().snakeToCamel()
    }
    
    /// convert to snake case to camel case
    /// e.g.) hoge_fuga => HogeFuga
    ///
    /// - Parameter separator: String
    /// - Returns: String
    func snakeToCamel(with separator: String = "_") -> String {
        let components = self.components(separatedBy: separator)
        return components.map { component -> String in
            let secondIndex = component.index(component.startIndex, offsetBy: 1)
            let firstChar = String(component[component.startIndex..<secondIndex])
            return component.replacingCharacters(in: component.startIndex..<secondIndex, with: firstChar.uppercased())
            }.joined()
    }
}
