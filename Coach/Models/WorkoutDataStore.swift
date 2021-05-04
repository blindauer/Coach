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
    private var cachedWorkouts = WorkoutLog()
    
    func store(_ entry: WorkoutLogEntry) {
        cachedWorkouts.append(entry)
        try? saveToDisk()
    }
    
    func load() -> WorkoutLog {
        return cachedWorkouts
    }
    
    private func saveToDisk() throws {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("workouts.json")

        try JSONSerialization.data(withJSONObject: cachedWorkouts)
            .write(to: fileURL)
    }
}
