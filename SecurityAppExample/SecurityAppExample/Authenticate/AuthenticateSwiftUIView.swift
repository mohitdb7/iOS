//
//  AuthenticateSwiftUIView.swift
//  SecurityAppExample
//
//  Created by Mohit Dubey on 10/06/24.
//

import SwiftUI

struct AuthenticateSwiftUIView: View {
    let vm = AuthenticateViewModel()
    @State var authType: AuthenticationType = .touchId
    var body: some View {
        VStack {
            Button {
                vm.authenticateUser()
            } label: {
                HStack {
                    Spacer()
                    Text("Authenticate")
                        
                    if authType == .touchId {
                        HStack {
                            Image(systemName: "touchid")
                            Text("With FingerPrint")
                        }
                    } else {
                        HStack {
                            Image(systemName: "faceid")
                            Text("With Face")
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            authType = vm.authenticationType()
        }
    }
}

#Preview {
    AuthenticateSwiftUIView()
}
