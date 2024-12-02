//
//  ContentView.swift
//  ConcurrencyTest
//
//  Created by Mohit Dubey on 30/05/24.
//

import SwiftUI

struct ContentView: View {
    var contentVM = ContentViewViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button(action: {
                
            }, label: {
                Text("Concurrent Operations")
                    .frame(minWidth: 200)
                    .frame(maxWidth: .infinity)
            })
            
            
            Button(action: {
                
            }, label: {
                Text("Parallel Operations")
                    .frame(minWidth: 200)
                    .frame(maxWidth: .infinity)
            })
            
            
            Button(action: {
                
            }, label: {
                Text("Await Operations")
                    .frame(minWidth: 200)
                    .frame(maxWidth: .infinity)
            })
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
