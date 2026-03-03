//
//  TimerView.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 12/02/26.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var timerModel: TimerModel
    
    var body: some View {
        
        Text(timerModel.elapsedTime,
             format: .time(pattern: .hourMinuteSecond))
            .font(.subheadline)
            .monospacedDigit()
        }
}

