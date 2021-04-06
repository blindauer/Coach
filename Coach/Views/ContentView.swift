//
//  ContentView.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coach = Coach()
    private var workout = Workout.data[0]
    
    var body: some View {
        VStack {
            Text(workout.name)
                .font(.headline)
            Spacer()
            Button(action: {
                if coach.workoutInProgress {
                    coach.stopWorkout()
                } else {
                    coach.start(workout: workout)
                }
            }, label: {
                PlayButtonView(workoutInProgress: coach.workoutInProgress)
            })
            List {
                ForEach(workout.exercises) { exercise in
                    ExerciseRowView(coach: coach, exercise: exercise)
                }
            }
        }
    }
}

struct PlayButtonView: View {
    let workoutInProgress: Bool
    
    var body: some View {
        let buttonImage = VStack {
            if workoutInProgress {
                Image(systemName:"pause.fill")
            } else {
                Image(systemName:"play.fill")
            }
        }
        
        buttonImage
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
        HStack {
            if let current = coach.currentExercise, exercise.id == current.id {
                Text(exercise.name)
                    .bold()
            } else {
                Text(exercise.name)
            }
            Spacer()
            Text("\(Int(exercise.duration))s")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
