//
//  FactsNetworkDomain.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FactsNetworkDomain {
    @ObservableState
    struct State: Equatable {
        var number: Int = 0
        var facts: String?
        var isLoading: Bool = false
    }
    
    enum Action {
        case generateRandomNumber
        case factsButtonTapped
        case factsButtonResponse(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .generateRandomNumber:
                state.number = Int.random(in: 0..<10)
                return .none
            case .factsButtonTapped:
                state.isLoading = true
                state.facts = nil
                
                return .run { [number = state.number] send in
                    
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(number)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factsButtonResponse(fact))
                }
                
            case let .factsButtonResponse(response):
                state.facts = response
                state.isLoading = false
                return .none
            }
        }
    }
}
