//
//  GoalView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct GoalView: View {
    
    @Binding var goal: Goal
    
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isPresented_Goal_AddTask: Bool = false
    var isFirst: Bool {
        goal.tasks.count == 0
    }
    
    var body: some View {
        ZStack {
            Color("WhiteBlack")
                .ignoresSafeArea(edges: .all)
            VStack(spacing: 0) {
                HStack {
                    backButton
                    Spacer()
                    Text(goal.name)
                        .modifier(Prime_Title())
                        .lineLimit(1)
                    Spacer()
                    
                    if isFirst {
                        emptyTrailingNavSpace
                    } else {
                        AddTaskButton(isModal: $isPresented_Goal_AddTask, goal: $goal)
                    }
                }
                
                List {
                    ForEach($goal.tasks, id: \.id) { $task in
                        NavigationLink {
                            TaskView(task: $task)
                        } label: {
                            Text(task.name)
                                .tracking(0.5)
                                .modifier(Rubik_Text())
                                .frame(height: 40)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(action: {
                                viewModel.removeTask(goal: goal, task: task)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
//                    .onDelete { i in
//                        viewModel.removeTask(goal: goal, item: i)
//                    }
                    .listRowBackground(Color("WhiteBlack"))
                }
                .listStyle(.plain)
                
                if isFirst {
                    AddFirstButton(isModal: $isPresented_Goal_AddTask, goal: $goal)
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

extension GoalView {
    
    var backButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 24, weight: .light))
                .frame(maxWidth: 32)
                .foregroundColor(Color("BlackWhite"))
                .padding()
                .padding(.bottom, 8)
        }
    }
}

extension GoalView {
    
    var emptyTrailingNavSpace: some View {
        Button(action: {
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .light))
                .frame(maxWidth: 32)
                .foregroundColor(Color.init(white: 1, opacity: 0))
                .padding()
                .padding(.bottom, 8)
        }
    }
}

extension GoalView {
    
    struct AddTaskButton: View {
        
        @Binding var isModal: Bool
        @Binding var goal: Goal
        
        var body: some View {
            Button(action: {
                self.isModal = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .light))
                    .frame(maxWidth: 32)
                    .foregroundColor(Color("BlackWhite"))
                    .padding()
                    .padding(.bottom, 8)
            }
            .sheet(isPresented: $isModal) { Goal_AddTask(goal: $goal) }
        }
    }
}

extension GoalView {
    
    struct AddFirstButton: View {
        
        @EnvironmentObject var appTheme: AppTheme
        @Binding var isModal: Bool
        @Binding var goal: Goal
        
        var body: some View {
            Button(action: {
                isModal = true
            }) {
                ZStack{
                    Color.accentColor
                    Text("Add your first task")
                        .tracking(0.5)
                        .modifier(Rubik_Text_Bold())
                        .foregroundColor(.white)
                }
                .cornerRadius(10)
                .padding(.horizontal, appTheme.isSmall ? 14 : 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
            }
            .padding(.bottom, appTheme.isSmall ? 8 : 0)
            .sheet(isPresented: $isModal) { Goal_AddTask(goal: $goal) }
        }
    }
}
