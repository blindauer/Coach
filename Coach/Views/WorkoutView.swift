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
    @State private var isPresented = false
    @State private var newWorkoutData = Workout.Data()
    
    var body: some View {
        VStack {
            List {
                Section(header: sectionHeader) {
                    ForEach(workout.exercises) { exercise in
                        ExerciseRowView(coach: coach, exercise: exercise)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing: Button("Edit") {
                newWorkoutData = workout.data
                isPresented = true
            })
            .navigationTitle(workout.name)
            .fullScreenCover(isPresented: $isPresented) {
                NavigationView {
                    EditView(workout: $newWorkoutData)
                        .navigationTitle(workout.name)
                        .navigationBarItems(leading: Button("Cancel") {
                            isPresented = false
                        }, trailing: Button("Done") {
                            // TODO save workout
                            isPresented = false
                        })
                }
            }
            Spacer()
            WorkoutControlsView(
                workoutState: coach.workoutState,
                startAction: { coach.start(workout: workout) },
                pauseAction: { coach.pauseWorkout() },
                resumeAction: { coach.resumeWorkout() },
                stopAction: { coach.stopWorkout() }
            )
        }
    }
    
    var sectionHeader: some View {
        if coach.workoutState == .active || coach.workoutState == .paused {
            return Text("Set \(coach.currentSet) of \(workout.numberOfSets)")
        } else {
            return Text(format(sets: workout.numberOfSets))
        }
    }
    
    func format(sets: Int) -> String {
        "\(sets) \(sets == 1 ? "set" : "sets")"
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

struct ExerciseRowView: View {
    @StateObject var coach: Coach
    let exercise: Exercise
    
    var body: some View {
        ZStack {
            // TODO - for testing for "current" exercise.
//            Capsule()
//                .strokeBorder(Color.blue, lineWidth: 2)
//                .background(Capsule().fill(Color.white))
            HStack {
                if isCurrent(exercise: exercise) {
                    Text(exercise.name)
                        .bold()
                } else {
                    Text(exercise.name)
                }
                Spacer()
                if isCurrent(exercise: exercise),
                   let timeLeft = coach.currentExerciseTimeLeft
                {
                    Text("\(Int(timeLeft))s")
                        .bold()
                } else {
                    Text("\(Int(exercise.duration))s")
                }
            }
        }
    }
    
    private func isCurrent(exercise: Exercise) -> Bool {
        guard let currentExercise = coach.currentExercise else { return false }
        return exercise == currentExercise
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
