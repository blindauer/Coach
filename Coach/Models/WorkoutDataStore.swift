//
//  WorkoutDataStore.swift
//  Coach
//
//  Created by Bradley Lindauer on 4/27/21.
//

import Foundation

protocol WorkoutStorable {
    func store(_ entry: WorkoutLogEntry)
    func load() -> WorkoutLog
}

class WorkoutDataStore: WorkoutStorable {
    private var allWorkouts = WorkoutLog()
    
    func store(_ entry: WorkoutLogEntry) {
        allWorkouts.append(entry)
    }
    
    func load() -> WorkoutLog {
        return allWorkouts
    }
}
