//
//  FileReadPropertyWrapper.swift
//  HeroNavigationExample
//
//  Created by Mohit Dubey on 22/02/24.
//

import Foundation

@propertyWrapper
struct FileWithUrl {
    var fileNameWithExtension: String
    
    var wrappedValue: URL? {
        let fileNameAndExtension = fileNameWithExtension.split(separator: ".")
        if fileNameAndExtension.count > 1 {
            return Bundle.main.url(forResource: String(fileNameAndExtension.first!), withExtension: String(fileNameAndExtension.last!))
        }
        
        return nil
    }
    
    var projectedValue: String {
        fileNameWithExtension
    }
}

@propertyWrapper
struct FileWithData {
    var fileNameWithExtension: String
    var defaultValue: Data? = nil
    
    var wrappedValue: Data? {
        mutating get {
            if let defaultValue {
                return defaultValue
            }
            
            @FileWithUrl(fileNameWithExtension: fileNameWithExtension)
            var fileWithUrl: URL?
            if let fileWithUrl {
                do {
                    let data = try Data(contentsOf: fileWithUrl)
                    self.defaultValue = data
                    return data
                } catch let error {
                    print("Error in reading file \(error.localizedDescription)")
                }
            }
            
            return nil
        }
    }
}
