//
//  Untitled.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 02/12/24.
//
import Foundation
import ComposableArchitecture

@Reducer
struct TabbedHomeDomain {
    
    @ObservableState
    struct State: Equatable {
        var cartState = AddToCartButtonDomain.State()
        var factStore = FactsNetworkDomain.State()
        var timerStore = TimerDomain.State()
    }
    
    enum Action {
        case cartState(AddToCartButtonDomain.Action)
        case factStore(FactsNetworkDomain.Action)
        case timerStore(TimerDomain.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.cartState, action: \.cartState) {
            AddToCartButtonDomain()
        }
        Scope(state: \.factStore, action: \.factStore) {
            FactsNetworkDomain()
        }
        Scope(state: \.timerStore, action: \.timerStore) {
            TimerDomain()
        }
        Reduce { state, action in
            return .none
        }
    }
    
}
