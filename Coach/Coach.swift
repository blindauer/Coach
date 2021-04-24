//
//  Coach.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import UIKit

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
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        perform(workout)
    }
    
    func pauseWorkout() {
        // TODO
    }
    
    func stopWorkout() {
        workout = nil
        workoutInProgress = false
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func perform(_ workout: Workout) {
        self.workout = workout
        workoutInProgress = true
        currentSet = 1

        let workoutSteps = WorkoutCompiler().steps(from: workout)
        schedule(steps: workoutSteps)
    }
    
    private func schedule(steps: [WorkoutStep]) {
        guard let currentStep = steps.first else {
            stopWorkout()
            return
        }
        
        schedule(step: currentStep)
        workoutSteps = Array(steps.dropFirst())
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
