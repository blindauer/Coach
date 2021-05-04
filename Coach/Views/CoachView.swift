//
//  CoachView.swift
//  Coach
//
//  Created by Bradley Lindauer on 5/4/21.
//

import SwiftUI

struct CoachView: View {
    @Binding var workouts: [Workout]
  
    var body: some View {
        List {
            ForEach(workouts) { workout in
                NavigationLink(destination: WorkoutView(workout: binding(for: workout))) {
                    WorkoutRowView(workout: workout)
                }
            }
        }
        .navigationTitle("Workouts")
    }
    
    private func binding(for workout: Workout) -> Binding<Workout> {
        guard let index = workouts.firstIndex(where: { $0.id == workout.id }) else {
            fatalError("Can't find workout in array")
        }
        return $workouts[index]
    }
}

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        Text(workout.name)
    }
}


struct CoachView_Previews: PreviewProvider {
    static var previews: some View {
        CoachView(workouts: .constant(Workout.data))
    }
}
