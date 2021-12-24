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
    @State private var taskDate: Date = Date()
    @State private var isSameName = false
    @State private var isEmptyName = false
    @State private var selectedRegularity: Regularity = .weekly
    enum Regularity: String, CaseIterable {
        case weekly = "Weekly"
        case once = "Once"
    }
    @State var weekdays = [WeeklyDate(label: "M", weekday: "Monday", isActive: false),
                    WeeklyDate(label: "T", weekday: "Tuesday", isActive: false),
                    WeeklyDate(label: "W", weekday: "Wednesday", isActive: false),
                    WeeklyDate(label: "T", weekday: "Thursday", isActive: false),
                    WeeklyDate(label: "F", weekday: "Friday", isActive: false),
                    WeeklyDate(label: "S", weekday: "Saturday", isActive: false),
                    WeeklyDate(label: "S", weekday: "Sunday", isActive: false)
    ]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("New task")
                    .modifier(Prime_Header())
                    .foregroundColor(Color("BlackWhite"))
                    .padding(.top, 80)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Task name")
                        .modifier(Prime_Title())
                        .foregroundColor(Color("White"))
                        .padding(.top, 26)
                        .padding(.horizontal, 20)
                    
                    TextField("", text: $taskName)
                        .accentColor(Color.white)
                        .placeholder(when: taskName.isEmpty) {
                            Text("Formulate task...")
                                .tracking(0.5)
                                .foregroundColor(Color("White"))
                        }
                        .lineSpacing(0)
                        .modifier(Rubik_Text())
                        .foregroundColor(Color("White"))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 22)
                }
                .background(Color("PlaceholderBackground"))
                .cornerRadius(10)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                Text("* Let's set a specific task to achieve this goal")
                    .tracking(0.5)
                    .modifier(Rubik_Info())
                    .foregroundColor(Color("BlackWhite").opacity(0.6))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 22)
                
                Divider()
                    .frame(maxHeight: 2)
                    .padding(.horizontal, 24)
                
                Picker(selection: $selectedRegularity, label: EmptyView()) {
                    ForEach(Regularity.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 12)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if selectedRegularity == .weekly {
                    HStack {
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(weekdays.indices) { index in
                                ZStack {
                                    Circle()
                                        .fill(weekdays[index].isActive == true ? Color.accentColor : Color.gray)
                                        .cornerRadius(40)
                                        .frame(width: 40, alignment: .center)
                                    Text("\(weekdays[index].label)")
                                        .modifier(Rubik_Text())
                                        .foregroundColor(Color("White"))
                                }
                                .onTapGesture {
                                    weekdays[index].isActive.toggle()
                                }
                            }
                        }
                        Spacer()
                    }
                } else {
                    DatePicker("Task date", selection: $taskDate, in: Date()..., displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .padding(.leading, 20)
                }
                
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
                        taskName.isEmpty ? appTheme.InactiveButtonColor["fill"] : appTheme.ActiveButtonColor["fill"]
                        Text("Create")
                            .tracking(0.5)
                            .modifier(Rubik_Text_Bold())
                            .foregroundColor(taskName.isEmpty ? appTheme.InactiveButtonColor["color"] : appTheme.ActiveButtonColor["color"])
                    }
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: 56)
                }
                .padding(.horizontal, appTheme.isSmall ? 14 : 20)
                .padding(.bottom, appTheme.isSmall ? 8 : 0)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .blur(radius: isSameName || isEmptyName ? 10 : 0)
            .overlay(isSameName || isEmptyName ? Color.black.opacity(0.35).ignoresSafeArea(.all) : nil)
            .disabled(isSameName || isEmptyName)
            
            SameNameError(isError: $isSameName,
                          title: SameNameError.TitleText.task.rawValue,
                          message: SameNameError.MessageText.task.rawValue,
                          dismissButton: SameNameError.DismissButtonText.task.rawValue)
            EmptyNameError(isError: $isEmptyName,
                           title: EmptyNameError.TitleText.task.rawValue,
                           message: EmptyNameError.MessageText.task.rawValue,
                           dismissButton: EmptyNameError.DismissButtonText.task.rawValue)
        }
    }
}
