//
//  DataExtension.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 07/09/24.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
