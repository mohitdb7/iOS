//
//  DictionaryExtension.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import Foundation

extension Dictionary {
    mutating func merge(_ collection: Dictionary, replaceExisting: Bool = false) {
        for (key, value) in collection {
            if !replaceExisting, let _ = self[key] {
                continue
            }
            
            self[key] = value
        }
    }
}
