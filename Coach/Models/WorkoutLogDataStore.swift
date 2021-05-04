//
//  WorkoutLogDataStore.swift
//  Coach
//
//  Created by Bradley Lindauer on 5/4/21.
//

import Foundation

protocol WorkoutLogStorable {
    func store(_ entry: WorkoutLogEntry)
    func load() -> WorkoutLog
}

class WorkoutLogDataStore: WorkoutLogStorable {
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
            .appendingPathComponent(WorkoutsFileName)

        try JSONSerialization.data(withJSONObject: cachedWorkouts)
            .write(to: fileURL)
    }
    
    private let WorkoutsFileName = "WorkoutLog.json"
}
