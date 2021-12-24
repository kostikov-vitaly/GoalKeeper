//
//  Main_AddGoal.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct Main_AddGoal: View {
    
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var appTheme: AppTheme
    @Environment(\.dismiss) var dismiss
    
    @State private var goalName: String = ""
    @State private var isSameName = false
    @State private var isEmptyName = false
    @State private var isManyGoals = false
    @State var selectedAreaIndex: Int = 0
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("New goal")
                    .modifier(Prime_Header())
                    .foregroundColor(Color("BlackWhite"))
                    .padding(.top, 80)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Goal name")
                        .modifier(Prime_Title())
                        .foregroundColor(Color("White"))
                        .padding(.top, 26)
                        .padding(.horizontal, 20)
                    
                    TextField("", text: $goalName)
                        .accentColor(Color.white)
                        .placeholder(when: goalName.isEmpty) {
                            Text("What do you wanna reach?")
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
                
                Text("* Little hint. You will be able to close your goals faster if they are made according to the SMART system. This condition will also help the goals to be more effective for your life.")
                    .tracking(0.5)
                    .modifier(Rubik_Info())
                    .lineLimit(appTheme.isSmall ? 2 : nil)
                    .foregroundColor(Color("BlackWhite").opacity(0.6))
                    .padding(.horizontal, 24)
                    .padding(.bottom, appTheme.isSmall ? 0 : 22)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Select life area")
                        .modifier(Prime_Title())
                        .foregroundColor(Color("BlackWhite"))
                    Picker(selection: $selectedAreaIndex, label: EmptyView()) {
                        ForEach(0..<viewModel.areas.count) {
                            Text(viewModel.areas[$0].name)
                                .modifier(Rubik_LargeText())
                                .foregroundColor(Color("BlackWhite"))
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .padding(.top, appTheme.isSmall ? 0 : 40)
                
                Button(action: {
                    if goalName.isEmpty {
                        isEmptyName = true
                    } else if viewModel.checkGoalsNumberWhenAdd(area: viewModel.areas[selectedAreaIndex]) {
                        isManyGoals = true
                    } else if !viewModel.areas.flatMap({$0.goals}).map({$0.name.lowercased()}).contains(goalName.lowercased()) {
                        viewModel.addGoalToArea(area: viewModel.areas[selectedAreaIndex], name: goalName)
                        dismiss()
                    } else {
                        isSameName = true
                    }
                    
                }) {
                    ZStack{
                        goalName.isEmpty ? appTheme.InactiveButtonColor["fill"] : appTheme.ActiveButtonColor["fill"]
                        Text("Create")
                            .tracking(0.5)
                            .modifier(Rubik_Text_Bold())
                            .foregroundColor(goalName.isEmpty ? appTheme.InactiveButtonColor["color"] : appTheme.ActiveButtonColor["color"])
                    }
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: 56)
                }
                .padding(.horizontal, appTheme.isSmall ? 14 : 20)
                .padding(.bottom, appTheme.isSmall ? 8 : 0)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .blur(radius: isSameName || isEmptyName || isManyGoals ? 10 : 0)
            .overlay(isSameName || isEmptyName || isManyGoals ? Color.black.opacity(0.35).ignoresSafeArea(.all) : nil)
            .disabled(isSameName || isEmptyName || isManyGoals)
            
            TooManyError(isError: $isManyGoals)
            SameNameError(isError: $isSameName,
                          title: SameNameError.TitleText.goal.rawValue,
                          message: SameNameError.MessageText.goal.rawValue,
                          dismissButton: SameNameError.DismissButtonText.goal.rawValue)
            EmptyNameError(isError: $isEmptyName,
                           title: EmptyNameError.TitleText.goal.rawValue,
                           message: EmptyNameError.MessageText.goal.rawValue,
                           dismissButton: EmptyNameError.DismissButtonText.goal.rawValue)
        }
        
    }
}
