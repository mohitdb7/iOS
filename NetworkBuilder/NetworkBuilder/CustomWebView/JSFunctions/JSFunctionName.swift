//
//  JSFunctionName.swift
//  CustomControlsBootcampUIKIT
//
//  Created by mohit.dubey on 21/06/23.
//

import Foundation

enum JSFunctionName: String, CaseIterable {
    case getAppVersion
    case giveMeValues
}

struct JSFunctionNames {
    static let listOfReturnJSFunc: [String: Any] = [
        JSFunctionName.getAppVersion.rawValue : JSFunctionsStore.getAppVersion()
    ]
    
    static let listOfReceiveJSFunctions: [String : [String]] = [
        JSFunctionName.giveMeValues.rawValue : ["stringValueParam", "intValueParam"]
    ]
}
