//
//  String+Extensions.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

extension String {
    func convertToKey(with separator: String) -> String {
        let components = self.components(separatedBy: separator).dropFirst()
        return components.map { component -> String in
            let secondIndex = component.index(component.startIndex, offsetBy: 1)
            let firstChar = String(component[component.startIndex..<secondIndex])
            return component.replacingCharacters(in: component.startIndex..<secondIndex, with: firstChar.uppercased())
        }.joined()
    }
}
