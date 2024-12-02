//
//  FactsButton.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import SwiftUI
import ComposableArchitecture

struct FactsButton: View {
    let store: StoreOf<FactsNetworkDomain>
    
    var body: some View {
        VStack {
            HStack {
                if store.number == 0 {
                    Text("Select a number")
                        .frame(minWidth: 100)
                } else {
                    Text("Your number is \(store.number)")
                        .frame(minWidth: 100)
                }
                
                Spacer()
                
                Button {
                    store.send(.generateRandomNumber, animation: .default)
                } label: {
                    Text("Generate Number")
                }
                .buttonStyle(.borderedProminent)

            }
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
            
            if store.number != 0 {
                if let facts = store.facts {
                    Text("Fact is \(facts)")
                }
                
                Button {
                    store.send(.factsButtonTapped)
                } label: {
                    Text("Get Facts")
                }
                .buttonStyle(.borderedProminent)
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .disabled(store.isLoading)

            }
        }
    }
}

#Preview {
    FactsButton(store: Store(initialState: FactsNetworkDomain.State(), reducer: {
        FactsNetworkDomain()
    }))
}
