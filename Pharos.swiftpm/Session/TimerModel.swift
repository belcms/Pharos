//
//  TimerModel.swift
//  ssc26 Bel
//
//  Created by Isabel Cristina Marras Salles on 12/02/26.
//

import SwiftUI
import Combine

class TimerModel: ObservableObject {
    @Published var elapsedTime: Duration = .zero
    @Published var isTimerRunning: Bool = false
    
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var cancellable: Cancellable?
    
    init() {
        isTimerRunning = true
        cancellable = timer.sink { [weak self] _ in
            guard let self = self else { return }
            if self.isTimerRunning {
                self.elapsedTime += .seconds(1)
            }
        }
    }
    
    func startPause(){
        isTimerRunning.toggle()
    }
    
    func reset(){
        elapsedTime = .zero
        isTimerRunning = false
    }
}
