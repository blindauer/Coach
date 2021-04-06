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

class Coach: ObservableObject {
    private let announcer = Announcer()
    private var workout: Workout?
    private var exercises: [Exercise]?
    private var workoutSteps: [WorkoutStep]?
    
    @Published var workoutInProgress = false
    @Published var currentExercise: Exercise?
    @Published var timeLeft: TimeInterval?
    
    func announce(_ string: String) {
        announcer.speak(string)
    }
}

extension Coach: Coaching {
    func start(workout: Workout) {
        self.workout = workout
        self.exercises = workout.exercises
        self.workoutInProgress = true
        
        if let exercise = exercises?.first {
            perform(exercise: exercise)
        }
    }
    
    func pauseWorkout() {
        // TODO
    }
    
    func stopWorkout() {
        workout = nil
        exercises = nil
        workoutInProgress = false
    }
    
    private func perform(exercise: Exercise) {
        currentExercise = exercise
        let exerciseSteps = steps(from: exercise)
        schedule(steps: exerciseSteps)
    }
    
    private func schedule(steps: [WorkoutStep]) {
        guard let currentStep = steps.first else {
            // Done with current exercise. Do next.
            exercises?.removeFirst()
            if let exercise = exercises?.first {
                perform(exercise: exercise)
            } else {
                stopWorkout()
            }
            return
        }
        
        workoutSteps = Array(steps.dropFirst())
        schedule(step: currentStep)
    }
    
    private func schedule(step: WorkoutStep) {
        let nextStepDelay: TimeInterval
        
        switch step {
        case .delay(let delay):
            nextStepDelay = delay
        case .announce(let announcement):
            announcer.speak(announcement)
            nextStepDelay = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + nextStepDelay) { [weak self] in
            guard let self = self else { return }
            guard let remainingSteps = self.workoutSteps else { return }
            self.schedule(steps: remainingSteps)
        }
    }
}

extension Coach {
    private enum WorkoutStep {
        case delay(TimeInterval)
        case announce(String)
    }
    
    private func steps(from exercise: Exercise) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        steps.append(.announce("\(exercise.name), \(Int(exercise.duration)) seconds, starting in 10 seconds."))
        steps.append(.delay(10))
        steps.append(contentsOf: countdown(from: 5))
        steps.append(.announce("Go!"))
        steps.append(.delay(exercise.duration - 10))
        steps.append(.announce("10 seconds left."))
        steps.append(.delay(5))
        steps.append(contentsOf: countdown(from: 5))
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
