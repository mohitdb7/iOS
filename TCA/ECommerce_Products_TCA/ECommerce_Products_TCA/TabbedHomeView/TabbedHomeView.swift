//
//  TabbedHomeView.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 02/12/24.
//

import SwiftUI
import ComposableArchitecture

struct TabbedHomeView: View {
    let store: StoreOf<TabbedHomeDomain>
    var body: some View {
        TabView {
            AddToCartButtonView(store: store.scope(state: \.cartState, action: \.cartState))
                .tabItem {
                    VStack {
                        Image(systemName: "suitcase.cart")
                        Text("Add to Cart")
                    }
                }
            
            FactsButton(store: store.scope(state: \.factStore, action: \.factStore))
                .tabItem {
                    VStack {
                        Image(systemName: "globe.asia.australia")
                        Text("Facts Check")
                    }
                }
            
            TimerButtonView(store: store.scope(state: \.timerStore, action: \.timerStore))
                .tabItem {
                    VStack {
                        Image(systemName: "timer")
                        Text("Time Check")
                    }
                }
        }
    }
}

#Preview {
    TabbedHomeView(store: Store(initialState: TabbedHomeDomain.State(), reducer: {
        TabbedHomeDomain()
    }))
}
