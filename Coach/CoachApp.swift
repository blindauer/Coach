//
//  CoachApp.swift
//  Coach
//
//  Created by Bradley Lindauer on 3/24/21.
//

import SwiftUI

@main
struct CoachApp: App {
    @State private var workouts = Workout.data
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CoachView(workouts: $workouts)
            }
        }
    }
}
