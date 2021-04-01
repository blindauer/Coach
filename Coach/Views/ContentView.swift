//
//  ContentView.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import SwiftUI

struct ContentView: View {
    private let coach = Coach()
    private let workout = Workout.data[0]
    
    var body: some View {
        VStack {
            Text(workout.name)
                .font(.headline)
            Spacer()
            Button(action: {
                coach.start(workout: workout)
            }, label: {
                PlayButtonView()
            })
            List {
                ForEach(workout.exercises) { exercise in
                    ExerciseRowView(exercise: exercise)
                }
            }
        }
    }
}

struct PlayButtonView: View {
    var body: some View {
        Image(systemName:"play.fill")
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
    let exercise: Exercise
    
    var body: some View {
        HStack {
            Text(exercise.name)
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
