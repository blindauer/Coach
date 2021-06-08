//
//  EditView.swift
//  Coach
//
//  Created by Bradley Lindauer on 5/26/21.
//

import SwiftUI

struct EditView: View {
    @Binding var workout: Workout.Data
    @State private var newExerciseDuration = 30
    @State private var editMode: EditMode = .active
    @State private var exerciseName = ""
    
    var body: some View {
        List {
            Section(header: Text("Workout")) {
                TextField("Title", text: $workout.name)
                HStack {
                    Slider(value: $workout.numberOfSets, in: 1...10, step: 1) {
                        Text("Sets")
                    }
                    .accessibilityValue(Text("\(Int(workout.numberOfSets)) sets"))
                    Spacer()
                    Text("\(Int(workout.numberOfSets)) sets")
                        .accessibilityHidden(true)
                }
                HStack {
                    Slider(value: $workout.restBetweenSets, in: 0...120, step: 5) {
                        Text("Rest")
                    }
                    .accessibilityValue(Text("\(Int(workout.restBetweenSets)) seconds rest"))
                    Spacer()
                    Text("\(Int(workout.restBetweenSets))s rest")
                        .accessibilityHidden(true)
                }
            }
            Section(header: exercisesListHeader) {
                ForEach(0..<workout.exercises.count) { index in
                    HStack {
                        TextField("Name", text: $workout.exercises[index].name)
                        Spacer()
                        Text("\(Int(workout.exercises[index].duration))s")
                    }
                }
                .onDelete { indices in
                    workout.exercises.remove(atOffsets: indices)
                }
                .onMove(perform: { indices, newOffset in
                    workout.exercises.move(fromOffsets: indices, toOffset: newOffset)
                })
            }
        }
        .listStyle(InsetGroupedListStyle())
        .environment(\.editMode, $editMode)
    }
    
    var exercisesListHeader: some View {
        HStack {
            Text("Exercises")
            Spacer()
            Button(action: {
                withAnimation {
                    let newExercise = Exercise.Data(name: "New Exercise", duration: 30)
                    workout.exercises.append(newExercise)
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .accessibilityLabel(Text("Add exercise"))
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(workout: .constant(Workout.data[0].data))
    }
}
