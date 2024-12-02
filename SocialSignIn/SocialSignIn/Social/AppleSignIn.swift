//
//  AppleSignIn.swift
//  SocialSignIn
//
//  Created by Mohit Dubey on 28/08/24.
//

import Foundation
import AuthenticationServices

class AppleSocialSignIn: NSObject, SocialSignIn, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding  {
    private var appleIDProvider: ASAuthorizationAppleIDProvider?
    var authorizationController: ASAuthorizationController?
    
    func setup() {
        appleIDProvider = ASAuthorizationAppleIDProvider()
        guard let appleIDProvider else {
            return
        }
        
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        guard let authorizationController else {
            return
        }
        authorizationController.delegate = self
    }
    
    func signIn() {
        authorizationController?.performRequests()
    }
}

extension AppleSocialSignIn {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("Error is \(error.localizedDescription)")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print(appleIDCredential.identityToken)
            print(userIdentifier)
            print(fullName ?? "Fullname Not Found")
            print(email ?? "Email Not Found")
        }
    }
}
