//
//  WorkoutCompiler.swift
//  Coach
//
//  Created by Bradley Lindauer on 4/24/21.
//

import Foundation

struct WorkoutStep {
    enum Kind {
        case announce(String)
        case setNumber(Int)
        case start(Exercise)
        case stopExercise
    }
    let kind: Kind
    let time: TimeInterval
    
    init(_ kind: Kind, time: TimeInterval = 0) {
        self.kind = kind
        self.time = time
    }
}

/// Compile a workout to a list of steps.
class WorkoutCompiler {
    var currentTimeDelta: TimeInterval = 0
    var workoutSteps = [WorkoutStep]()
    
    func steps(from workout: Workout) -> [WorkoutStep] {
        append(step: .announce("")) // TODO figure out why this needs to be here.
        append(step: .announce("Workout: \(workout.name)."))
        append(delay: 5)
        append(step: .announce("\(workout.numberOfSets) sets."))
        append(delay: 2)
                
        for setNumber in 1...workout.numberOfSets {
            append(step: .setNumber(setNumber))
            append(step: .announce("Set number \(setNumber)."))
            append(delay: 2)
            for exercise in workout.exercises {
                append(exercise: exercise)
            }
            if setNumber < workout.numberOfSets {
                append(restTime: workout.restBetweenSets)
            }
        }
        
        append(step: .announce("\(workout.name) complete."))
        append(delay: 3)
        append(step: .announce(randomCompleteMessage()))
        
        return workoutSteps
    }
    
    private func append(step: WorkoutStep.Kind) {
        let step = WorkoutStep(step, time: currentTimeDelta)
        workoutSteps.append(step)
    }

    private func append(delay: TimeInterval) {
        currentTimeDelta += delay
    }
    
    private func append(exercise: Exercise) {
        append(step: .announce("\(exercise.name), \(Int(exercise.duration)) seconds, starting in 10 seconds."))
        append(delay: 10)
        append(countdownFrom: 5)
        append(step: .announce("Go!"))
        append(step: .start(exercise))
        append(delay: exercise.duration - 10)
        append(step: .announce("10 seconds left."))
        append(delay: 5)
        append(countdownFrom: 5)
        append(step: .stopExercise)
    }
    
    private func append(countdownFrom seconds: TimeInterval) {
        for x in (1...Int(seconds)).reversed() {
            append(step: .announce("\(x)."))
            append(delay: 1)
        }
    }
    
    private func append(restTime: TimeInterval) {
        append(step: .announce("Rest: \(Int(restTime)) seconds."))
        append(delay: restTime - 8)
        append(step: .announce("Rest ending in 5 seconds."))
        append(delay: 5)
    }
    
    private func randomCompleteMessage() -> String {
        return [
            "Nice job!",
            "Bro, you are swole!",
            "Are you totally ripped yet?",
            "Next time, more sets, I.M.O."
        ].randomElement() ?? ""
    }
}
