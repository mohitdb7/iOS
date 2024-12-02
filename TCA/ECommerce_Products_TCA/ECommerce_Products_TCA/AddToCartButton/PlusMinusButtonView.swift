//
//  PlusMinusButtonView.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import SwiftUI
import ComposableArchitecture


struct PlusMinusButtonView: View {
    let store: StoreOf<AddToCartButtonDomain>
    
    var body: some View {
        HStack {
            Button {
                store.send(.didTapOnMinusButton, animation: .default)
            } label: {
                Text("-")
                    .bold()
                    .font(.system(size: 20))
                    .frame(minWidth: 24)
            }
            .buttonStyle(.borderedProminent)
            
            
            Text("\(store.count.description)")
                .bold()
                .font(.system(size: 20))
                .frame(minWidth: 30)
            
            Button {
                store.send(.didTapOnPlusButton, animation: .default)
            } label: {
                Text("+")
                    .bold()
                    .font(.system(size: 20))
                    .frame(minWidth: 24)
            }
            .buttonStyle(.borderedProminent)
            

        }
    }
}

#Preview {
    PlusMinusButtonView(store: Store(initialState: AddToCartButtonDomain.State(), reducer: {
        AddToCartButtonDomain()
    }))
}
