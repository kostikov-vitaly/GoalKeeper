//
//  Goal_AddTask.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct Goal_AddTask: View {
    
    @Binding var goal: Goal
    
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var appTheme: AppTheme
    @Environment(\.dismiss) var dismiss
    
    @State private var taskName: String = ""
    @State private var isSameName = false
    @State private var isEmptyName = false
    @State private var selectedRegularity: Regularity = .once
    enum Regularity: String, CaseIterable {
        case once = "Once"
        case repeatable = "Repeatable"
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color("AccentBlack")
                    .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("New task")
                        .modifier(Prime_Header())
                        .foregroundColor(Color("White"))
                        .padding(.leading, 22)
                        .padding(.trailing, 20)
                        .padding(.top, 80)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Task name")
                            .modifier(Prime_Title())
                            .padding(.top, 26)
                            .padding(.horizontal, 20)
                            .foregroundColor(Color("BlackWhite"))
                        TextField(text: $taskName) {
                            Text("Formulate task...")
                                .tracking(0.5)
                        }
                        .placeholder(when: taskName.isEmpty) {
                            Text("Formulate task...")
                                .tracking(0.5)
                                .foregroundColor(Color("PlaceholderColor"))
                        }
                        .lineSpacing(0)
                        .modifier(Rubik_Text())
                        .foregroundColor(.accentColor)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    }
                    .background(Color("PlaceholderBackground"))
                    .cornerRadius(10)
                    .padding()
                    .padding(.top, 16)
                    
                    Text("Let's set a specific task to achieve this goal")
                        .tracking(0.5)
                        .modifier(Rubik_Info())
                        .foregroundColor(Color("White").opacity(appTheme.isLight ? 0.85 : 0.6))
                        .padding(.leading, 22)
                        .padding(.trailing, 20)
                        .padding(.top, 4)
                    
                    Picker(selection: $selectedRegularity, label: EmptyView()) {
                        ForEach(Regularity.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Spacer()
                    
                    Text("\(selectedRegularity.rawValue)")
                        .foregroundColor(Color("White"))
                    
                    Spacer()
                    
                    Button(action: {
                        if taskName.isEmpty {
                            isEmptyName = true
                        } else if !viewModel.areas.flatMap({$0.goals}).flatMap({$0.tasks}).map({$0.name.lowercased()}).contains(taskName.lowercased()) {
                            viewModel.addTaskToGoal(goal: goal, name: taskName)
                            dismiss()
                        } else {
                            isSameName = true
                        }
                        
                    }) {
                        ZStack{
                            Color("White")
                            Text("Create")
                                .tracking(0.5)
                                .modifier(Rubik_Text_Bold())
                                .foregroundColor(Color("AccentBlack"))
                        }
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity, maxHeight: 56)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .blur(radius: isSameName || isEmptyName ? 10 : 0)
            .overlay(isSameName || isEmptyName ? Color.black.opacity(0.35).ignoresSafeArea(.all) : nil)
            .disabled(isSameName || isEmptyName)
            
            SameNameError(isSameName: $isSameName,
                          title: SameNameError.TitleText.task.rawValue,
                          message: SameNameError.MessageText.task.rawValue,
                          dismissButton: SameNameError.DismissButtonText.task.rawValue)
            EmptyNameError(isEmptyName: $isEmptyName,
                           title: EmptyNameError.TitleText.task.rawValue,
                           message: EmptyNameError.MessageText.task.rawValue,
                           dismissButton: EmptyNameError.DismissButtonText.task.rawValue)
        }
    }
}
