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
    private var workoutSteps: [WorkoutStep]?
    private var exerciseStart: Date?
    private var timer: Timer?
    
    @Published var workoutInProgress = false
    @Published var currentExercise: Exercise?
    @Published var currentExerciseTimeLeft: TimeInterval?
    @Published var currentSet: Int = 0
    
    var timeLeft: TimeInterval? {
        guard let start = exerciseStart, let currentExercise = currentExercise else { return nil }
        return currentExercise.duration + start.timeIntervalSince(Date())
    }
    
    func announce(_ string: String) {
        announcer.speak(string)
    }
}

extension Coach: Coaching {
    func start(workout: Workout) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.currentExerciseTimeLeft = self.timeLeft
        }
        
        perform(workout)
    }
    
    func pauseWorkout() {
        // TODO
    }
    
    func stopWorkout() {
        workout = nil
        workoutInProgress = false
    }
    
    private func perform(_ workout: Workout) {
        self.workout = workout
        workoutInProgress = true
        currentSet = 1

        let workoutSteps = steps(from: workout)
        schedule(steps: workoutSteps)
    }
    
    private func schedule(steps: [WorkoutStep]) {
        guard let currentStep = steps.first else {
            stopWorkout()
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
        case .setNumber(let setNumber):
            currentSet = setNumber
            nextStepDelay = 0
        case .start(let exercise):
            exerciseStart = Date()
            currentExercise = exercise
            nextStepDelay = 0
        case .stopExercise:
            currentExercise = nil
            exerciseStart = nil
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
        case setNumber(Int)
        case start(Exercise)
        case stopExercise
    }
    
    private func steps(from workout: Workout) -> [WorkoutStep] {
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
                let exerciseSteps = steps(from: exercise)
                workoutSteps.append(contentsOf: exerciseSteps)
            }
            if setNumber < workout.numberOfSets {
                workoutSteps.append(.announce("Rest: \(Int(workout.restBetweenSets)) seconds."))
                workoutSteps.append(.delay(workout.restBetweenSets - 5))
                workoutSteps.append(contentsOf: countdown(from: 5))
            }
        }
        
        workoutSteps.append(.announce("\(workout.name) complete."))
        workoutSteps.append(.delay(3))
        workoutSteps.append(.announce("Nice job!"))
        
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
    
    private func countdown(from: TimeInterval) -> [WorkoutStep] {
        var steps = [WorkoutStep]()
        for x in (1...5).reversed() {
            steps.append(.announce("\(x)."))
            steps.append(.delay(1))
        }
        
        return steps
    }
}
