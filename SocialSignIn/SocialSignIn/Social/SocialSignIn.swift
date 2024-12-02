//
//  SocialSignIn.swift
//  SocialSignIn
//
//  Created by Mohit Dubey on 22/08/24.
//

import Foundation

enum SignInTypes: CaseIterable {
    case google
    case facebook
    case apple
    case instagram
}

protocol SocialSignIn: AnyObject {
    func setup()
    func signIn()
}

class SignInManager {
    
    private var signInClients: [SignInTypes : SocialSignIn] = [:]
    private var currentSignIn: SignInTypes?
    
    init() {
        setup()
    }
    
    private func setup() {
        for item in SignInTypes.allCases {
            switch item {
            case .google:
                signInClients[.google] = GoogleSocialSignIn()
                signInClients[.google]?.setup()
            case .facebook:
                break
            case .apple:
                signInClients[.apple] = AppleSocialSignIn()
                signInClients[.apple]?.setup()
            case .instagram:
                break
            }
        }
    }
    
    func signIn(to social: SignInTypes) {
        switch social {
        case .google:
            signInClients[.google]?.signIn()
        case .facebook:
            break
        case .apple:
            signInClients[.apple]?.signIn()
        case .instagram:
            break
        }
    }
}
