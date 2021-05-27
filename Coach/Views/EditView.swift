//
//  EditView.swift
//  Coach
//
//  Created by Bradley Lindauer on 5/26/21.
//

import SwiftUI

struct EditView: View {
    @Binding var workout: Workout.Data
    @State private var newExercise = ""
    @State private var newExerciseDuration = 30
    
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
                ForEach(workout.exercises, id: \.self) { exercise in
                    HStack {
                        Text(exercise.name)
                        Spacer()
                        Text("\(Int(exercise.duration))s")
                    }
                }
                .onDelete { indices in
                    workout.exercises.remove(atOffsets: indices)
                }
                .onMove(perform: { indices, newOffset in
                    workout.exercises.move(fromOffsets: indices, toOffset: newOffset)
                })
//                VStack {
//                    HStack {
//                        TextField("New Exercise", text: $newExercise)
//                        Button(action: {
//                            withAnimation {
//                                // TODO workout.exercises.append(newExercise)
//                                newExercise = ""
//                            }
//                        }) {
//                            Image(systemName: "plus.circle.fill")
//                                .accessibilityLabel(Text("Add exercise"))
//                        }
//                        .disabled(newExercise.isEmpty || newExerciseDuration == 0)
//                    }
//                    TextField("Duration", value: $newExerciseDuration, formatter: NumberFormatter())
//                        .keyboardType(UIKeyboardType.decimalPad)
//                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var exercisesListHeader: some View {
        HStack {
            Text("Exercises")
            Spacer()
            EditButton()
//            Spacer()
//            Button(action: {
//                withAnimation {
//                    // TODO workout.exercises.append(newExercise)
//                    newExercise = ""
//                }
//            }) {
//                Image(systemName: "plus.circle.fill")
//                    .accessibilityLabel(Text("Add exercise"))
//            }
            //.disabled(newExercise.isEmpty || newExerciseDuration == 0)
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(workout: .constant(Workout.data[0].data))
    }
}
