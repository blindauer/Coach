//
//  WorkoutView.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import SwiftUI

struct WorkoutView: View {
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
            Spacer()
            if coach.workoutInProgress {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
