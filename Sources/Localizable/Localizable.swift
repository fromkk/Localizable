//
//  Localizable.swift
//  Localizable
//
//  Created by Kazuya Ueoka on 2018/04/22.
//  Copyright © 2018 fromkk. All rights reserved.
//

import Foundation

class Localizable {
    let inputFile: String
    let outputDirectory: String
    let separator: String
    
    init(inputFile: String, outputDirectory: String, separator: String) {
        self.inputFile = inputFile
        self.outputDirectory = outputDirectory
        self.separator = separator
    }
    
    func generate() {
        let localizations = try! LocalizableParser(path: inputFile).parse()
        var files: Set<File> = []
        localizations.keys.forEach { (key) in
            let fileName = toFilename(for: key, with: separator)
            let file = File(fileName: fileName)
            if let index = files.index(of: file) {
                let other = files[index]
                other.keys += [key]
            } else {
                file.keys = [key]
                files.insert(file)
            }
        }
        
        files.forEach { (file) in
            file.generate(in: outputDirectory, with: separator)
        }
        
        print("done!")
        exit(0)
    }
    
    private func toFilename(for key: String, with separator: String) -> String {
        guard let firstKey = key.components(separatedBy: separator).first else {
            print("firstKey get failed")
            exit(1)
        }
        
        let startIndex = firstKey.startIndex
        let secondIndex = firstKey.index(startIndex, offsetBy: 1)
        let firstChar = String(firstKey[startIndex..<secondIndex]).uppercased()
        return firstKey.replacingCharacters(in: startIndex..<secondIndex, with: firstChar)
    }
}
