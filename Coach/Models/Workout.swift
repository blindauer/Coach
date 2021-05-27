//
//  Workout.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/29/21.
//

import Foundation

struct Exercise: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    let name: String
    let duration: TimeInterval
    
    init(id: UUID = UUID(), name: String, duration: TimeInterval) {
        self.id = id
        self.name = name
        self.duration = duration
    }
}

struct Workout: Codable, Identifiable {
    let id: UUID
    let name: String
    let exercises: [Exercise]
    let restBetweenExercises: TimeInterval
    let numberOfSets: Int
    let restBetweenSets: TimeInterval
}

extension Workout {
    struct Data {
        var name: String = ""
        var exercises: [Exercise] = []
        var restBetweenExercises: Double = 10
        var numberOfSets: Double = 3
        var restBetweenSets: Double = 60
    }
    
    var data: Data {
        return Data(
            name: name, exercises: exercises, restBetweenExercises: restBetweenSets,
            numberOfSets: Double(numberOfSets), restBetweenSets: restBetweenSets
        )
    }
}

extension Workout {
    static let data: [Workout] = [
        Workout(
            id: UUID(),
            name: "Rotisserie Core",
            exercises: [
                Exercise(name: "Superman", duration: 30.0),
                Exercise(name: "Left Side Plank", duration: 30.0),
                Exercise(name: "Crunches", duration: 30.0),
                Exercise(name: "Right Side Plank", duration: 30.0),
                Exercise(name: "Front Plank", duration: 30.0)
            ],
            restBetweenExercises: 10.0,
            numberOfSets: 3,
            restBetweenSets: 60.0
        )
    ]
}
