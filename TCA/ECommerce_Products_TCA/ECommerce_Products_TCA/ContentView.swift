//
//  ContentView.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let appStore: StoreOf<TabbedHomeDomain>
    
    var body: some View {
        
        TabbedHomeView(store: appStore)
    }
}

#Preview {
    ContentView(appStore: Store(initialState: TabbedHomeDomain.State(), reducer: {
        TabbedHomeDomain()
    }))
}
