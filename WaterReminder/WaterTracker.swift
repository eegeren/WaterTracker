//
//  WaterTracker.swift
//  WaterReminder
//
//  Created by Yusufege Eren on 2.07.2025.
//

import Foundation

class WaterReminder {
   static let shared = WaterReminder()
    
    private let goal = 2000 // ml
    private(set) var currentIntake = 0
    
    func addWater(amount: Int) {
        currentIntake += amount
        if currentIntake > goal {
            currentIntake = goal
        }
    }
    
    func reset() {
        currentIntake = 0
    }
    
    var progress: Float {
        return Float(currentIntake) / Float(goal)
    }
}
