//
//  AuthenticateViewModel.swift
//  SecurityAppExample
//
//  Created by Mohit Dubey on 10/06/24.
//

import Foundation


class AuthenticateViewModel {
    func authenticateUser() {
        Task {
            do {
                let result = try await AuthenticationManager.shared.authenticateUser()
                if result {
                    print("Authenticated...")
                } else {
                    print("Not Authenticated")
                }
            } catch let error {
                print("Error in authencating")
            }
        }
        
//        AuthenticationManager.shared.authenticateUser { success, error in
//            print("Authentication status \(success), error: \(error?.localizedDescription)")
//        }
    }
    
    func authenticationType() -> AuthenticationType {
        return AuthenticationManager.shared.getAuthenticationType()
    }
}
