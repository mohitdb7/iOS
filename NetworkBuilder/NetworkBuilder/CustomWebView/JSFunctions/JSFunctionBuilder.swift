//
//  JSFunctionBuilder.swift
//  CustomControlsBootcampUIKIT
//
//  Created by mohit.dubey on 21/06/23.
//

import Foundation

enum JSFunctionBuilder<ReturnType> {
    
    case returns(functionName: String, returnValue: ReturnType, isFunctionReturningParam: Bool = false, defaultValueOfParam: ReturnType? = nil)
    case receives(functionName: String, parameters: [String], extraParameter: [(String?, String?)?]? = nil)
    case receivesAndReturns(functionName: String, parameters: [String], returnValue: ReturnType, extraParameter: (String?, String?)? = nil)
    
    var generateSignature: String {
        switch self {
            case .returns(let functionName, let returnValue, let isFunctionReturningParam, let defaultValue):
                
                var returnParam = ""
                
                if isFunctionReturningParam, let defaultValueForParam = defaultValue {
                        //Ex: var param = defaultValue;
                    returnParam = "var \(returnValue) = \(getReturnValue(for: defaultValueForParam)); "
                    
                        //Ex: this.setParam = function(newValue) { param = newValue }
                    returnParam += "this.set\(returnValue) = function(newValue) { \(returnValue) = newValue };"
                }
                return "\(returnParam) this.\(functionName) = function() "
                
            case .receives(let functionName, let parameters, _):
                return "this.\(functionName) = function(\(parameters.joined(separator: ", "))) "
            case .receivesAndReturns(let functionName, let parameters, _, _):
                return "this.\(functionName) = function(\(parameters.joined(separator: ", "))) "
        }
    }
    
    var generateBody: String {
        switch self {
            case .returns( _, let returnValue, let isFunctionReturningParam, _):
                
                if isFunctionReturningParam {
                    let body = "return \(getParamReturnValue(for: returnValue));"
                    return "{   \(body) };"
                } else {
                    let body = "return \(getReturnValue(for: returnValue));"
                    return "{   \(body) };"
                }
                
            case .receives(let functionName, let parameters, let extraParameter):
                
                var statement = ""
                if let extraParam = extraParameter, !extraParam.isEmpty {
                    for param in extraParam {
                        if let paramStatement = param?.1 {
                            statement += paramStatement
                        }
                    }
                }
                
                let data = "var data = \(generatePostMessageString(from: parameters, extraParameter: extraParameter));"
                let messageHandler = "window.webkit.messageHandlers.\(functionName).postMessage(data);"
                return "{   \(statement)\(data)\(messageHandler) };"
                
            case .receivesAndReturns(let functionName, let parameters, let returnValue, let extraParameter):
                
                var statement = ""
                if let extraParam = extraParameter, let paramStatement = extraParam.1 {
                    statement += paramStatement
                }
                
                let data = "var data = \(generatePostMessageString(from: parameters));"
                let messageHandler = "window.webkit.messageHandlers.\(functionName).postMessage(data);"
                let body = "return \(getReturnValue(for: returnValue));"
                return "{   \(statement)\(data)\(messageHandler)\(body) };"
        }
    }
    
    func getReturnValue(for value: Any) -> Any {
        if value is String {
            return "'\(value)'"
        } else {
            return value
        }
    }
    
    func getParamReturnValue(for paramName: Any) -> Any {
        return paramName
    }
    
    func generatePostMessageString(from parameters: [String], extraParameter: [(String?, String?)?]? = nil) -> String {
        
        var paramString = "["
        var isFirstParam = true
        
        for param in parameters {
            if isFirstParam {
                isFirstParam = false
                paramString += "\(param)"
            } else {
                paramString += ", \(param)"
            }
        }
        
        if let extraParam = extraParameter, !extraParam.isEmpty {
            for param in extraParam {
                if let paramName = param?.0 {
                    paramString += isFirstParam ? "\(paramName)" : ", \(paramName)"
                }
            }
        }
        
        paramString += "]"
        
        return paramString
    }
    
}
