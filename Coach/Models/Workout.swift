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

extension Exercise {
    struct Data: Hashable {
        let id: UUID = UUID()
        var name: String = ""
        var duration: Double = 30
    }
    
    var data: Data {
        return Data(name: name, duration: duration)
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
        var exercises: [Exercise.Data] = []
        var restBetweenExercises: Double = 10
        var numberOfSets: Double = 3
        var restBetweenSets: Double = 60
    }
    
    var data: Data {
        return Data(
            name: name, exercises: exercises.map { Exercise.Data(name: $0.name, duration: $0.duration) },
            restBetweenExercises: restBetweenSets,
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
                Exercise(name: "Superman", duration: 35),
                Exercise(name: "Left Side Plank", duration: 35),
                Exercise(name: "Crunches", duration: 35),
                Exercise(name: "Right Side Plank", duration: 35),
                Exercise(name: "Front Plank", duration: 35)
            ],
            restBetweenExercises: 10.0,
            numberOfSets: 3,
            restBetweenSets: 60.0
        )
    ]
}
