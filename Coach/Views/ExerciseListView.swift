//
//  ExerciseListView.swift
//  Coach
//
//  Created by Bradley Lindauer on 4/16/21.
//

import SwiftUI

struct ExerciseListView: View {
    let coach: Coach
    let exercises: [Exercise]
    
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                ExerciseRowView(coach: coach, exercise: exercise)
            }
        }
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

struct ExerciseListView_Previews: PreviewProvider {
    static var coach = Coach()
    static var exercises = Workout.data[0].exercises
    
    static var previews: some View {
        ExerciseListView(coach: coach, exercises: exercises)
    }
}
