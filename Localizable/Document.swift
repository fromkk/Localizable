//
//  Document.swift
//  DuplicateLocalizationsPackageDescription
//
//  Created by Kazuya Ueoka on 2018/03/14.
//

import Foundation

public class Documents {
    private static let fileManager = FileManager.default
    
    private enum Constants {
        static let directorySeparator = "/"
    }
    
    public static func contents(in directory: String) -> [String] {
        return (try? fileManager.contentsOfDirectory(atPath: directory).filter({ (path) -> Bool in
            return path.prefix(1) != "."
        })) ?? []
    }
    
    public static func paths(in directory: String) -> [String] {
        return contents(in: directory).map {
            return directory + Constants.directorySeparator + $0
        }
    }
    
    public static func files(in directory: String) -> [String] {
        return paths(in: directory).filter { (path) -> Bool in
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
                return !isDirectory.boolValue
            } else {
                return false
            }
        }
    }
    
    public static func isDirectory(path: String) -> Bool {
        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    public static func directories(in directory: String) -> [String] {
        return paths(in: directory).filter { (path) -> Bool in
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
                return isDirectory.boolValue
            } else {
                return false
            }
        }
    }
    
    private static func recursiveFiles(in directory: String, result: [String]) -> [String] {
        var result = result
        result += files(in: directory)
        directories(in: directory).forEach { (currentDirectory) in
            result = self.recursiveFiles(in: currentDirectory, result: result)
        }
        return result
    }
    
    public static func allFiles(in directory: String) -> [String] {
        return recursiveFiles(in: directory, result: [])
    }
    
    public static func renameAllFiles(in directory: String, base: String, replace: String) {
        allFiles(in: directory).forEach { (path) in
            let old = path
            let new = old.replacingOccurrences(of: base, with: replace)
            
            if self.fileManager.fileExists(atPath: new) {
                do {
                    try self.fileManager.removeItem(atPath: new)
                } catch {
                    debugPrint(#function, "remove \(new) failed", error)
                }
            }
        }
        
        allFiles(in: directory).forEach { (path) in
            let old = path
            let new = old.replacingOccurrences(of: base, with: replace)
            
            do {
                try self.fileManager.moveItem(atPath: old, toPath: new)
            } catch {
                debugPrint(#function, error)
            }
        }
    }
}
