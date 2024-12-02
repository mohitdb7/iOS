//
//  ContentView.swift
//  NetworkBuilder
//
//  Created by Mohit Dubey on 31/08/24.
//

import SwiftUI

struct ContentView: View {
    let vm: FakeProductViewModel = FakeProductViewModel()
    
    var body: some View {
        VStack {
            Text("Products")
                .font(.largeTitle)
            Image("IMG_1098")
                .resizable()
                .scaledToFill()
            Button {
                vm.getProducts()
            } label: {
                Text("Get Products")
            }
            
            Button {
                vm.addProduct()
            } label: {
                Text("Add Product")
            }
            
            Button {
                vm.uploadImage()
            } label: {
                Text("Image Upload")
            }
            
            Button {
                vm.uploadVideo()
            } label: {
                Text("Video Upload")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
