//
//  LocalizableParser.swift
//  DuplicateLocalizationsPackageDescription
//
//  Created by Kazuya Ueoka on 2018/03/14.
//

import Foundation

public class LocalizableParser {
    
    /// defines of errors
    ///
    /// - notFound: Localizable.strings not found
    /// - convertFailed: data to string failed
    public enum Errors: Error {
        case notFound
        case convertFailed
    }
    
    /// path of Localizable.strings
    public let path: String
    public init(path: String) {
        self.path = path
    }
    
    /// perform perse for Localizable.strings
    ///
    /// - Returns: [String: String] key for name, value for message
    /// - Throws: Errors
    public func parse() throws -> [String: String] {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: path) else {
            throw Errors.notFound
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        
        guard let string = String(data: data, encoding: .utf8) else {
            throw Errors.convertFailed
        }
        
        return type(of: self).parse(string: string)
    }
    
    /// perform parse Localizable.strings contents
    ///
    /// - Parameter string: Localizable.strings contents
    /// - Returns: [String: String]
    public static func parse(string: String) -> [String: String] {
        let lines = string.components(separatedBy: "\n")
        return lines.compactMap({ (line) -> (key: String, value: String)? in
            let line = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            guard !line.isEmpty, !line.hasPrefix("//") else { return nil }
            return self.parse(line: line)
        }).reduce([:]) { (result, item) -> [String: String] in
            var res = result
            res[item.key] = item.value
            return res
        }
    }
    
    /// parse line for the Localizable.strings
    ///
    /// - Parameter line: String
    /// - Returns: (key: String, value: String)?
    public static func parse(line: String) -> (key: String, value: String)? {
        let results: [[String]] = regex.matches(in: line, options: [], range: (line as NSString).range(of: line)).map { (checkingResult: NSTextCheckingResult) -> [String] in
            return (0..<checkingResult.numberOfRanges).compactMap({ (i: Int) -> String? in
                guard checkingResult.range(at: i).location != NSNotFound else { return nil }
                return (line as NSString).substring(with: checkingResult.range(at: i))
            })
        }
        guard results.indices.contains(0), results[0].count == 3 else {
            return nil
        }
        
        return (results[0][1], results[0][2])
    }
    
    /// Regular expression for parse
    private static let regex = try! NSRegularExpression(pattern: "^\"(.*)\"\\s*=\\s*\"(.*)\";", options: [])
    
}
