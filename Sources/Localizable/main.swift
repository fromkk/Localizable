//
//  main.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

/// show help
func printHelp() {
    let help: String = """
    Usage: localizable --inputFile <inputFile> --outputDirectory <outputDirectory> [--separator <separator>]
    
    Options:
    --inputFile           set the input Localizable.strings file path
    --outputDirectory     set the path for output generated files
    --separator           set the separator. (defualt value is ".")
    """
    print(help)
}

let argument: [String: String] = Arguments().parse()

if let _ = argument["help"] {
    printHelp()
    exit(0)
}

guard let inputFile = argument["inputFile"] else {
    print("inputFile not setted")
    exit(1)
}

guard let outputDirectory = argument["outputDirectory"] else {
    print("outputDirectory not setted")
    exit(1)
}

let separator = argument["separator"] ?? "."

let fileManager = FileManager.default
guard fileManager.fileExists(atPath: inputFile) else {
    print("inputFile not exists")
    exit(1)
}

guard Documents.isDirectory(path: outputDirectory) else {
    print("outputDirectory is not directory")
    exit(1)
}

let localizableExtension = """
import Foundation

public protocol Localizable: RawRepresentable where RawValue == String {}

public extension Localizable {
    public func localized(tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(self.rawValue, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
}

"""

let dataExtension = localizableExtension.data(using: .utf8)!

try! dataExtension.write(to: URL(fileURLWithPath: outputDirectory).appendingPathComponent("Localizable.swift"))

let localization = """
import Foundation

public struct Localizations {}

"""

let dataLocalization = localization.data(using: .utf8)!

try! dataLocalization.write(to: URL(fileURLWithPath: outputDirectory).appendingPathComponent("Localization.swift"))

let localizable = Localizable(inputFile: inputFile, outputDirectory: outputDirectory, separator: separator)
localizable.generate()
