//
//  JSFunction.swift
//  CustomControlsBootcampUIKIT
//
//  Created by mohit.dubey on 21/06/23.
//

import Foundation

struct JSFunction {
    var signature: String
    var body: String
    
    init(for functionType: JSFunctionBuilder<Any>) {
        self.init(withSignature: functionType.generateSignature, Body: functionType.generateBody)
    }
    
    init(withSignature signature: String, Body body: String) {
        self.signature = signature
        self.body = body
    }
    
    private func toJSFunction(with context: String ) -> String {
        return "\(signature)\(body)"
    }
    
    private static let allFunctions: [JSFunction] =
    JSFunctionNames.listOfReturnJSFunc.map({ JSFunction(for: .returns(functionName: $0.key, returnValue: $0.value)) }) +
    JSFunctionNames.listOfReceiveJSFunctions.map({ JSFunction(for: .receives(functionName: $0.key, parameters: $0.value)) })
    
    static func returnJS(with action: String) -> String {
        var jsFunctions = ""
        for jsFunc in allFunctions {
            jsFunctions.append(jsFunc.toJSFunction(with: action))
        }
        let js = String(format: "var %@ = new function() { %@ };", action, jsFunctions)
        return js
    }
}
