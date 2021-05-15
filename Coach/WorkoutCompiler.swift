//
//  WorkoutCompiler.swift
//  Coach
//
//  Created by Bradley Lindauer on 4/24/21.
//

import Foundation

enum WorkoutStep {
    case delay(TimeInterval)
    case announce(String)
    case setNumber(Int)
    case start(Exercise)
    case stopExercise
}

struct ScheduledStep {
    let time: TimeInterval
    let step: Workout
}

/// Compile a workout to a list of steps.
class WorkoutCompiler {
    func steps(from workout: Workout) -> [WorkoutStep] {
        var workoutSteps = [WorkoutStep]()
        
        workoutSteps.append(.announce(""))  // TODO figure out why this needs to be here.
        workoutSteps.append(.announce("Workout: \(workout.name)."))
        workoutSteps.append(.delay(5))
        workoutSteps.append(.announce("\(workout.numberOfSets) sets."))
        workoutSteps.append(.delay(2))
                
        for setNumber in 1...workout.numberOfSets {
            workoutSteps.append(.setNumber(setNumber))
            workoutSteps.append(.announce("Set number \(setNumber)."))
            workoutSteps.append(.delay(2))
            for exercise in workout.exercises {
                workoutSteps.append(contentsOf: steps(from: exercise))
            }
            if setNumber < workout.numberOfSets {
                workoutSteps.append(contentsOf: rest(time: workout.restBetweenSets))
            }
        }
        
        workoutSteps.append(.announce("\(workout.name) complete."))
        workoutSteps.append(.delay(3))
        workoutSteps.append(.announce(randomCompleteMessage()))
        
        return workoutSteps
    }
    
    private func steps(from exercise: Exercise) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        steps.append(.announce("\(exercise.name), \(Int(exercise.duration)) seconds, starting in 10 seconds."))
        steps.append(.delay(10))
        steps.append(contentsOf: countdown(from: 5))
        steps.append(.announce("Go!"))
        steps.append(.start(exercise))
        steps.append(.delay(exercise.duration - 10))
        steps.append(.announce("10 seconds left."))
        steps.append(.delay(5))
        steps.append(contentsOf: countdown(from: 5))
        steps.append(.stopExercise)
        return steps
    }
    
    private func countdown(from seconds: TimeInterval) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        for x in (1...Int(seconds)).reversed() {
            steps.append(.announce("\(x)."))
            steps.append(.delay(1))
        }
        
        return steps
    }
    
    private func rest(time: TimeInterval) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        steps.append(.announce("Rest: \(Int(time)) seconds."))
        steps.append(.delay(time - 8))
        steps.append(.announce("Rest ending in 5 seconds."))
        steps.append(.delay(5))
        return steps
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
