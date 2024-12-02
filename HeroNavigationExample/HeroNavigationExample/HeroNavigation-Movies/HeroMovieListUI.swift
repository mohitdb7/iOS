//
//  HeroMovieListUI.swift
//  HeroNavigationExample
//
//  Created by Mohit Dubey on 22/02/24.
//

import SwiftUI

struct HeroMovieListUI: View {
    @ObservedObject var vm: MovieNavigationViewModel
    @State var showDetails = false
    @State var currentItem: MovieModel?
    
    @Namespace var animation: Namespace.ID
    
    @State var animateView: Bool = false
    var listdata = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth"]
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                VStack{
                    Spacer()
                    Rectangle()
                        .matchedGeometryEffect(id: "rect", in: animation)
                        .frame(width: 200, height: 100)
                        .onTapGesture {
                            withAnimation {
                                showDetails.toggle()
                            }
                        }
                    Spacer()
                }
            }
            Spacer()
        }
        .overlay {
            if showDetails {
                DetailView()
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func DetailView() -> some View {
        VStack {
            ZStack(alignment: .top) {
                Rectangle()
                    .matchedGeometryEffect(id: "rect", in: animation)
                    .frame(height: 400)
                    .onTapGesture {
                        withAnimation {
                            showDetails.toggle()
                        }
                    }
                HStack {
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
                .padding(.top)
                .padding()
                .safeAreaPadding([.top, .trailing])
            }
            .transition(.identity)
            
            List(listdata, id: \.self) { item in
                Text(item)
            }
            .frame(minHeight: 200)
            
            Spacer()
        }
    }
}
#Preview {
    HeroMovieListUI(vm: MovieNavigationViewModel())
}

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
