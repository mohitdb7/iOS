//
//  ContentView.swift
//  SocialSignIn
//
//  Created by Mohit Dubey on 22/08/24.
//

import SwiftUI

struct ContentView: View {
    var signInManager = SignInManager()
    
    var body: some View {
        VStack {
            Button {
                signInManager.signIn(to: .apple)
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "apple.logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Sign In with Apple")
                    Spacer()
                }
                .font(.headline)
                .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
            
            Button {
                signInManager.signIn(to: .google)
            } label: {
                HStack {
                    Spacer()
                    Image("Google")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Sign In with Google")
                    Spacer()
                }
                .font(.headline)
                .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
