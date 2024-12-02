//
//  TimerButtonView.swift
//  ECommerce_Products_TCA
//
//  Created by Mohit Dubey on 25/11/24.
//

import SwiftUI
import ComposableArchitecture

struct TimerButtonView: View {
    let store: StoreOf<TimerDomain>
    
    var body: some View {
        HStack {
            HStack {
                Text("Timer tick:")
                Text("\(store.timerTick)")
                    .monospacedDigit()
                    
            }.frame(minWidth: 150)
            Button {
                store.send(.toggleTimerButtonTapped, animation: .default)
            } label: {
                if !store.isTimerRunning {
                    Text("Start timer")
                        .frame(minWidth: 80)
                } else{
                    Text("End timer")
                        .frame(minWidth: 80)
                }
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
}

#Preview {
    TimerButtonView(store: Store(initialState: TimerDomain.State(),
                                 reducer: {
        TimerDomain()
    }))
}
