//
//  AddToCartButtonDomain.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddToCartButtonDomain {
    @ObservableState
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case didTapOnPlusButton
        case didTapOnMinusButton
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didTapOnPlusButton:
                state.count += 1
                
                return .none
            case .didTapOnMinusButton:
                if state.count > 0 {
                    state.count -= 1
                }
                
                return .none
            }
        }
    }
}

