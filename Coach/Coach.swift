//
//  Coach.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import Foundation

protocol Coaching {
    func start(workout: Workout)
    func pauseWorkout()
    func stopWorkout()
}

class Coach {
    private let announcer = Announcer()
    private var workout: Workout?
    private var workoutSteps: [WorkoutStep]?
    private var currentStepIndex = 0
    
    func announce(_ string: String) {
        announcer.speak(string)
    }
}

extension Coach: Coaching {
    func start(workout: Workout) {
        self.workout = workout
        let workoutSteps = steps(from: workout)
        schedule(steps: workoutSteps)
    }
    
    func pauseWorkout() {
        // TODO
    }
    
    func stopWorkout() {
        // TODO
    }
    
    private func schedule(steps: [WorkoutStep]) {
        currentStepIndex = 0
        workoutSteps = steps
        
        scheduleCurrentStep()
    }
    
    private func scheduleCurrentStep() {
        guard let steps = workoutSteps, currentStepIndex < steps.count else {
            stopWorkout()
            return
        }
        
        let step = steps[currentStepIndex]
        let nextStepDelay: TimeInterval
        
        switch step {
        case .delay(let delay):
            nextStepDelay = delay
        case .announce(let announcement):
            announcer.speak(announcement)
            nextStepDelay = 0
        }
        
        currentStepIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + nextStepDelay) { [weak self] in
            self?.scheduleCurrentStep()
        }
    }
}

extension Coach {
    private enum WorkoutStep {
        case delay(TimeInterval)
        case announce(String)
    }
    
    private func steps(from workout: Workout) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        for exercise in workout.exercises {
            steps.append(.announce("\(exercise.name), \(Int(exercise.duration)) seconds, starting in 5 seconds."))
            steps.append(.delay(5))
            steps.append(contentsOf: countdown(from: 5))
            steps.append(.announce("Go!"))
            steps.append(.delay(exercise.duration - 10))
            steps.append(.announce("10 seconds left."))
            steps.append(.delay(5))
            steps.append(contentsOf: countdown(from: 5))
        }
        
        return steps
    }
    
    private func countdown(from: TimeInterval) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        for x in (1...5).reversed() {
            steps.append(.announce("\(x)."))
            steps.append(.delay(1))
        }
        
        return steps
    }
}
