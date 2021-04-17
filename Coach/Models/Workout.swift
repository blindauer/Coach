//
//  Workout.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/29/21.
//

import Foundation

struct Exercise: Identifiable {
    let id: UUID
    let name: String
    let duration: TimeInterval
    
    init(id: UUID = UUID(), name: String, duration: TimeInterval) {
        self.id = id
        self.name = name
        self.duration = duration
    }
}

struct Workout {
    let name: String
    let exercises: [Exercise]
    let restBetweenExercises: TimeInterval
    let numberOfSets: Int
    let restBetweenSets: TimeInterval
}

extension Workout {
    static let data: [Workout] = [
        Workout(
            name: "Rotisserie Core",
            exercises: [
                Exercise(name: "Superman", duration: 40.0),
                Exercise(name: "Left Side Plank", duration: 35.0),
                Exercise(name: "Crunches", duration: 40.0),
                Exercise(name: "Right Side Plank", duration: 35.0),
                Exercise(name: "Front Plank", duration: 30.0)
            ],
            restBetweenExercises: 10.0,
            numberOfSets: 2,
            restBetweenSets: 60.0
        )
    ]
}
