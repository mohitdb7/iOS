//
//  JSFunctions.swift
//  CustomControlsBootcampUIKIT
//
//  Created by mohit.dubey on 21/06/23.
//

import Foundation

struct JSFunctionsStore {
//    static let jsFuncs: [JSFunction]
}

extension JSFunctionsStore {
    static func getAppVersion() -> String {
        "\(Bundle.main.releaseVersionNumber):\(Bundle.main.buildVersionNumber)"
    }
}

extension JSFunctionsStore {
    static func giveMeValues(stringValueParam: String, intValueParam: String) {
        print("stringValueParam: \(stringValueParam), intValueParam: \(intValueParam)")
    }
}
