//
//  AutofillSwiftUIView.swift
//  SecurityAppExample
//
//  Created by Mohit Dubey on 10/06/24.
//

import SwiftUI

struct AutofillSwiftUIView: View {
    @State var userName: String = ""
    @State var password: String = ""
    @State var newPassword: String = ""
    var body: some View {
        VStack {
            TextField("Enter your name", text: $userName)
            .textContentType(.username)
//            TextField("Enter Passowrd", text: $password)
//            .textContentType(.password)
            TextField("Enter New Passowrd", text: $newPassword)
            .textContentType(.newPassword)
        }
    }
}

#Preview {
    AutofillSwiftUIView()
}
