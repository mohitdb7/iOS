//
//  WebSwiftUIView.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 02/09/24.
//

import SwiftUI

struct WebSwiftUIView: View {
    var body: some View {
        //"tel://+919611886748" //"https://www.verse.in/"
       CustomWebViewSwiftView(navigateTo: URL(string: "https://www.kodeco.com/5456-in-app-purchase-tutorial-getting-started")!)
    }
}

#Preview {
    WebSwiftUIView()
}
