//
//  ECommerce_Products_TCAApp.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct ECommerce_Products_TCAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(appStore: Store(initialState: TabbedHomeDomain.State(), reducer: {
                TabbedHomeDomain()
            }))
        }
    }
}
