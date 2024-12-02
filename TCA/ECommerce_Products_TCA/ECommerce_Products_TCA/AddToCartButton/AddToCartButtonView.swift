//
//  AddToCartButton.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import SwiftUI
import ComposableArchitecture

struct AddToCartButtonView: View {
    let store: StoreOf<AddToCartButtonDomain>
    
    var body: some View {
        if store.count > 0 {
            PlusMinusButtonView(store: store)
        } else {
            Button {
                store.send(.didTapOnPlusButton, animation: .default)
            } label: {
                Text("Add to Cart")
                    .frame(minWidth: 120)
            }
            .buttonStyle(.borderedProminent)
        }

    }
}

#Preview {
    AddToCartButtonView(store: Store(initialState: AddToCartButtonDomain.State(), reducer: {
        AddToCartButtonDomain()
    }))
}
