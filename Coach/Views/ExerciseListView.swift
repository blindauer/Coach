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
        HStack {
            if let current = coach.currentExercise, exercise.id == current.id {
                Text(exercise.name)
                    .bold()
            } else {
                Text(exercise.name)
            }
            Spacer()
            if let current = coach.currentExercise,
               exercise.id == current.id,
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

struct ExerciseListView_Previews: PreviewProvider {
    static var coach = Coach()
    static var exercises = Workout.data[0].exercises
    
    static var previews: some View {
        ExerciseListView(coach: coach, exercises: exercises)
    }
}
