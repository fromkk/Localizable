//
//  FIle.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

class File: Equatable, Hashable, CustomStringConvertible {
    init(fileName: String) {
        self.fileName = fileName
    }
    
    let fileName: String
    var keys: [String] = []
    
    func generate(in outputDirectory: String, with separator: String) {
        let cases = keys.map { key -> String in
            return String(format: "        case %@ = \"%@\"", key.convertToKey(with: separator), key)
        }.joined(separator: "\n")
        
        let result = """
public extension Localizations {
    public enum \(fileName): Localizable {
\(cases)
    }
}
"""
        let data = result.data(using: .utf8)!
        let url = URL(fileURLWithPath: outputDirectory).appendingPathComponent(String(format: "%@.swift", fileName))
        try! data.write(to: url)
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        return lhs.fileName == rhs.fileName
    }
    
    var hashValue: Int { return fileName.hashValue }
    
    var description: String {
        return String(format: "File {fileName: %@, keys: %@}", fileName, keys)
    }
}
