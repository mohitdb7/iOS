//
//  GoogleSocialSignIn.swift
//  SocialSignIn
//
//  Created by Mohit Dubey on 22/08/24.
//

import Foundation
import GoogleSignIn

class GoogleSocialSignIn: SocialSignIn {
    func setup() {
        
    }
    
    func signIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            print(result)
        }
    }
}
