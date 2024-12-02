//
//  BundleExtension.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 02/09/24.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
