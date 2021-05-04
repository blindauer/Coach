//
//  WorkoutLog.swift
//  Coach
//
//  Created by Bradley Lindauer on 5/4/21.
//

import Foundation

struct WorkoutLogEntry: Codable {
    let date: Date
    let duration: TimeInterval
    let workout: Workout
}

typealias WorkoutLog = [WorkoutLogEntry]
