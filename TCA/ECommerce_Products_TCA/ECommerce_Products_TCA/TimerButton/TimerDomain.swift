//
//  TimerDomain.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TimerDomain {
    
    @ObservableState
    struct State: Equatable {
        var timerTick: Int = 0
        var isTimerRunning: Bool = false
    }
    
    enum Action {
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelId {
        case timer
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            switch action {
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                
                if state.isTimerRunning {
                    
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelId.timer)
                } else {
                    state.timerTick = 0
                    return .cancel(id: CancelId.timer)
                }
                
            case .timerTick:
                state.timerTick += 1
                return .none
            }
            
        }
    }
}
