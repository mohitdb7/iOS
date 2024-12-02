//
//  AuthenticationManager.swift
//  SecurityAppExample
//
//  Created by Mohit Dubey on 10/06/24.
//

import Foundation
import LocalAuthentication

enum AuthenticationError: Error {
    case noContext
}

enum AuthenticationType {
    case touchId
    case faceId
}

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private var context: LAContext?
    
    private init() {
        context = LAContext()
    }
    
    deinit {
        context = nil
    }
    
    // deviceOwnerAuthentication is used for FaceId, for devices where it is not available, it will return false. deviceOwnerAuthenticationWithBiometrics is to authenticate using the fingerPrint. The value for this is true even when only touchId is present so we should check the condition only when deviceOwnerAuthentication is false.
    // If faceId fails then enter passcode will be shown by default. But if we set the policy to deviceOwnerAuthenticationWithBiometrics then we need to explicitly show it. Hence, we should make sure that the policy is set to deviceOwnerAuthentication for TouchId devices
    private func isBiometricAvailable() throws -> Bool {
        var failureReason : NSError?
        if let context {
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &failureReason) {
                return false
            } else if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &failureReason) {
                return true
            } else {
                if let failureReason {
                    throw failureReason
                }
                return false
            }
        } else {
            throw AuthenticationError.noContext
        }
    }
    
    func getAuthenticationType() -> AuthenticationType {
        if (try? isBiometricAvailable()) == true {
            return .touchId
        } else {
            return .faceId
        }
    }
    
    
    private func errorMessage(errorCode:Int) -> String{
        var strMessage = ""
        switch errorCode {
        case LAError.Code.authenticationFailed.rawValue: strMessage = "Authentication Failed"
        case LAError.Code.appCancel.rawValue: strMessage = "User Cancel"
        case LAError.Code.systemCancel.rawValue: strMessage = "System Cancel"
        case LAError.Code.passcodeNotSet.rawValue: strMessage = "Please goto the Settings & Turn On Passcode"
        case LAError.Code.touchIDNotAvailable.rawValue: strMessage = "TouchI or FaceID DNot Available"
        case LAError.Code.touchIDNotEnrolled.rawValue: strMessage = "TouchID or FaceID Not Enrolled"
        case LAError.Code.touchIDLockout.rawValue: strMessage = "TouchID or FaceID Lockout Please goto the Settings & Turn On   Passcode"
        case LAError.Code.appCancel.rawValue: strMessage = "App Cancel"
        case LAError.Code.invalidContext.rawValue: strMessage = "Invalid Context"
        case LAError.Code.userCancel.rawValue: strMessage = "User Cancelled the authentication"
        default: strMessage = ""
        }
        return strMessage
    }
    
    // If faceId fails then enter passcode will be shown by default. But if we set the policy to deviceOwnerAuthenticationWithBiometrics then we need to explicitly show it. Hence, we should make sure that the policy is set to deviceOwnerAuthentication for TouchId devices
    func authenticateUser() async throws -> Bool {
        do {
            if try isBiometricAvailable() {
                guard (try await context?.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use TouchId to authenticate")) == true else {
                    return false
                }
            } else {
                guard (try await context?.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Use TouchId to authenticate")) == true else {
                    return false
                }
            }
            return true
        } catch let error {
            print("Error in executing the authentication \(error.localizedDescription)")
            if error is LAError {
                print(errorMessage(errorCode: error._code))
            }
            return false
        }
    }
    
    // If faceId fails then enter passcode will be shown by default. But if we set the policy to deviceOwnerAuthenticationWithBiometrics then we need to explicitly show it. Hence, we should make sure that the policy is set to deviceOwnerAuthentication for TouchId devices
    func authenticateUser(_ completion: @escaping (Bool, Error?) -> Void) {
        do {
            var policy = LAPolicy.deviceOwnerAuthentication
            if try isBiometricAvailable() {
                policy = .deviceOwnerAuthenticationWithBiometrics
            } else {
                policy = .deviceOwnerAuthentication
            }
            context?.evaluatePolicy(policy, localizedReason: "Authenticate yourself to access", reply: { success, authenticationError in
                completion(success, authenticationError)
            })
        } catch let error {
            print("Error in executing the authentication \(error.localizedDescription)")
            if error is LAError {
                print(errorMessage(errorCode: error._code))
            }
            completion(false, error)
        }
    }
    
}
