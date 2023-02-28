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
        append(step: .announce("\(workout.name)."))
        append(delay: 5)
        if workout.numberOfSets > 1 {
            append(step: .announce("\(workout.numberOfSets) sets."))
            append(delay: 2)
        }
                
        for setNumber in 1...workout.numberOfSets {
            append(step: .setNumber(setNumber))
            if workout.numberOfSets > 1 {
                append(step: .announce("Set \(setNumber)."))
                append(delay: 2)
            }
            for exercise in workout.exercises {
                append(exercise: exercise)
                if exercise != workout.exercises.last{
                    append(restTime: workout.restBetweenExercises)
                }
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
        let has10SecondWarning = exercise.duration > 30
        
        append(step: .announce("\(exercise.name), \(Int(exercise.duration)) seconds."))
        append(delay: 4)
        append(countdownFrom: 5)
        append(step: .announce("Go!"))
        append(step: .start(exercise))
        if has10SecondWarning {
            append(delay: exercise.duration - 10)
            append(step: .announce("10 seconds left."))
             append(delay: 5)
        } else {
            append(delay: exercise.duration - 5)
        }
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
        append(step: .announce("Rest ending in 5."))
        append(delay: 5)
    }
    
    private func randomCompleteMessage() -> String {
        return [
            "Nice job!",
            "Bro, you are swole!",
            "Are you totally ripped yet?",
            "Next time, more sets, I.M.O.",
            "Pain is temporary. Quitting lasts forever.",
            "Bodybuilding isn’t 90 minutes in the gym. It’s a lifestyle.",
            "The clock is ticking. Are you becoming the person you want to be?",
            "The question isn’t who is going to let me; it’s who is going to stop me.",
            "Intensity builds immensity.",
            "If something stands between you and your success, move it. Never be denied.",
            "You don’t find willpower; you create it.",
            "There is no strength without the struggle.",
            "Victory isn’t defined by wins and losses; it’s defined by effort.",
            "The pain you feel today is the strength you’ll feel tomorrow.",
            "Success usually comes to those who are too busy to be looking for it.",
            "Wanting something is not enough. You must hunger for it.",
            "Whether you think you can, or you think you can’t, you’re right.",
            "The pain of discipline is nothing like the pain of disappointment.",
            "Pain is a weakness leaving the body.",
            "Ain’t nothin’ to it, but to do it.",
            "Take care of your body. It’s the only place you have to live.",
            "No pain, no gain.",
            "It never gets easier. You just get stronger.",
            "Excuses don’t burn calories.",
            "Don’t count the days; make the days count."
        ].randomElement() ?? ""
    }
}
