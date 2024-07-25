//
//  Content-ViewModel.swift
//  Pomodoro
//
//  Created by Manya Gupta on 5/29/24.
//

import Foundation

extension ContentView{
    
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var is25 = true
        @Published var is50 = false
        @Published var isStudying = true
        @Published var showingAlert = false
        @Published var time: String = "25:00"
        @Published var minutes: Float = 25.0 {
            didSet {
                self.time = "\(Int(minutes)):00"
            }
        }
        
        @Published var progress: Double = 1.0
        
        
        
        private var initialTime = 0
        private var endDate = Date()
        
        func start(minutes: Float) {
            self.initialTime = Int(minutes)
            self.endDate = Date()
            self.isActive = true
            self.progress = 1.0
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
        }
        
        func reset() {
            self.minutes = Float(initialTime)
            self.isActive = false
            self.progress = 0.0
            self.time = "\(Int(minutes)):00"
        }
        
        func updateCountdown() {
            guard isActive else { return }
            
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.progress = 0.0
                self.showingAlert = true // MARK: Here you can add stuff to let user know that the timer is finished.
                return
            }
            
            self.progress = max(0.0, min(1.0, diff / Double(initialTime * 60)))
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.minutes = Float(minutes)
            self.time = String(format: "%d:%02d", minutes, seconds)
            
        }
        
    }
    
    
}
