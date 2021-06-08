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
    func resumeWorkout()
    func stopWorkout()
}

class Coach: ObservableObject {
    private let announcer = Announcer()
    private var workoutSteps: [WorkoutStep]?
    private var currentStepIndex: Int = 0
    private var workoutStart: Date?
    private var exerciseStart: Date?
    private var pauseTime: Date?
    private var timer: Timer?
    
    enum WorkoutState {
        case idle
        case active
        case paused
    }
    
    @Published var workoutState = WorkoutState.idle
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
        workoutSteps = WorkoutCompiler().steps(from: workout)
        
        workoutState = .active
        workoutStart = Date()
        currentStepIndex = 0
        
        startTimer()
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func pauseWorkout() {
        stopTimer()
        workoutState = .paused
        pauseTime = Date()
        announcer.stopSpeaking()
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func resumeWorkout() {
        guard workoutSteps != nil else { return }

        workoutState = .active
        if let pausedTime = pauseTime {
            let timePaused = Date().timeIntervalSince(pausedTime)
            workoutStart = workoutStart?.addingTimeInterval(timePaused)
            exerciseStart = exerciseStart?.addingTimeInterval(timePaused)
            pauseTime = nil
        }
        startTimer()
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func stopWorkout() {
        stopTimer()
        workoutState = .idle
        workoutStart = nil
        workoutSteps = nil
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(workoutTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func workoutTimer() {
        guard
            let steps = workoutSteps,
            let startTime = workoutStart,
            currentStepIndex < steps.count
        else {
            stopWorkout()
            return
        }
        
        let currentStep = steps[currentStepIndex]
        if Date().timeIntervalSince(startTime) > currentStep.time {
            execute(step: currentStep)
            currentStepIndex += 1
        }

        if let timeLeft = timeLeft {
            currentExerciseTimeLeft = timeLeft + 1
        }
    }
    
    private func execute(step: WorkoutStep) {
        switch step.kind {
        case .announce(let announcement):
            announcer.speak(announcement)
        case .setNumber(let setNumber):
            currentSet = setNumber
        case .start(let exercise):
            exerciseStart = Date()
            currentExercise = exercise
        case .stopExercise:
            currentExercise = nil
            exerciseStart = nil
        }
    }
}
