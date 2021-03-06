//
//  WorkoutDataStore.swift
//  Coach
//
//  Created by Bradley Lindauer on 4/27/21.
//

import Foundation

protocol WorkoutStorable {
    func store(_ workouts: [Workout])
    func load() -> [Workout]
}

class WorkoutDataStore: WorkoutStorable {
    private var cachedWorkouts = [Workout]()
    
    func store(_ workouts: [Workout]) {
        cachedWorkouts = workouts
        try? saveToDisk()
    }
    
    func load() -> [Workout] {
        return cachedWorkouts
    }
    
    private func saveToDisk() throws {
        let fileURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(WorkoutsFileName)

        try JSONSerialization.data(withJSONObject: cachedWorkouts)
            .write(to: fileURL)
    }
    
    private let WorkoutsFileName = "Workouts.json"
}
