//
//  WorkoutView.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import SwiftUI

struct WorkoutView: View {
    @Binding var workout: Workout
    @StateObject private var coach = Coach()
    
    var body: some View {
        VStack {
            Text(workout.name)
                .font(.headline)
            Spacer()
            WorkoutControlsView(
                workoutState: coach.workoutState,
                startAction: { coach.start(workout: workout) },
                pauseAction: { coach.pauseWorkout() },
                resumeAction: { coach.resumeWorkout() },
                stopAction: { coach.stopWorkout() }
            )
            Spacer()
            if coach.workoutState == .active || coach.workoutState == .paused {
                Text("Set \(coach.currentSet) of \(workout.numberOfSets)")
                    .font(.caption)
            } else if workout.numberOfSets > 1 {
                Text("\(workout.numberOfSets) sets")
                    .font(.caption)
            } else {
                /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
            }
            ExerciseListView(coach: coach, exercises: workout.exercises)
        }
    }
}

struct WorkoutControlsView: View {
    let workoutState: Coach.WorkoutState
    let startAction: () -> Void
    let pauseAction: () -> Void
    let resumeAction: () -> Void
    let stopAction: () -> Void
    
    var body: some View {
        switch workoutState {
        case .idle:
            Button(action: {
                startAction()
            }, label: {
                Image(systemName: "play.fill")
            })
            .buttonStyle(WorkoutControlButtonStyle())
        case .active:
            Button(action: {
                pauseAction()
            }, label: {
                Image(systemName: "pause.fill")
            })
            .buttonStyle(WorkoutControlButtonStyle())
        case .paused:
            HStack {
                Button(action: {
                    stopAction()
                }, label: {
                    Image(systemName: "xmark")
                })
                .buttonStyle(WorkoutControlButtonStyle())
                Button(action: {
                    resumeAction()
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
                .buttonStyle(WorkoutControlButtonStyle())
            }
        }
    }
}

struct WorkoutControlButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title)
            .foregroundColor(.blue)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.blue, lineWidth: 5)
            )
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workout: .constant(Workout.data[0]))
    }
}

struct WorkoutControlsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutControlsView(
            workoutState: .idle,
            startAction: {},
            pauseAction: {},
            resumeAction: {},
            stopAction: {}
        )
        WorkoutControlsView(
            workoutState: .active,
            startAction: {},
            pauseAction: {},
            resumeAction: {},
            stopAction: {}
        )
        WorkoutControlsView(
            workoutState: .paused,
            startAction: {},
            pauseAction: {},
            resumeAction: {},
            stopAction: {}
        )
    }
}
