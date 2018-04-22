//
//  main.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

let argument: Argument = Argument()
argument.parse()

guard let inputFile = argument.inputFile else {
    fatalError("inputFile not setted")
}

guard let outputDirectory = argument.outputDirectory else {
    fatalError("outputDirectory not setted")
}

let fileManager = FileManager.default
guard fileManager.fileExists(atPath: inputFile) else {
    fatalError("inputFile not exists")
}

guard Documents.isDirectory(path: outputDirectory) else {
    fatalError("outputDirectory is not directory")
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

let localizable = Localizable(inputFile: inputFile, outputDirectory: outputDirectory, separator: argument.separator)
localizable.generate()
