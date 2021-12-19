//
//  Area_AddGoal.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct Area_AddGoal: View {
    
    @Binding var area: Area
    
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var appTheme: AppTheme
    @Environment(\.dismiss) var dismiss
    
    @State private var goalName: String = ""
    @State private var isSameName = false
    @State private var isEmptyName = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color("AccentBlack")
                    .ignoresSafeArea(edges: .all)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("New goal")
                        .modifier(Prime_Header())
                        .foregroundColor(Color("White"))
                        .padding(.leading, 22)
                        .padding(.trailing, 20)
                        .padding(.top, 80)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Goal name")
                            .modifier(Prime_Title())
                            .padding(.top, 26)
                            .padding(.horizontal, 20)
                            .foregroundColor(Color("BlackWhite"))
                        TextField(text: $goalName) {
                            Text("What do you wanna reach?")
                                .tracking(0.5)
                        }
                        .placeholder(when: goalName.isEmpty) {
                            Text("What do you wanna reach?")
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
                    
                    Text("Little hint. You will be able to close your goals faster if they are made according to the SMART system. This condition will also help the goals to be more effective for your life.")
                        .tracking(0.5)
                        .modifier(Rubik_Info())
                        .foregroundColor(Color("White").opacity(appTheme.isLight ? 0.85 : 0.6))
                        .padding(.leading, 22)
                        .padding(.trailing, 20)
                        .padding(.top, 4)
                    Spacer()
                    
                    Button(action: {
                        if goalName.isEmpty {
                            isEmptyName = true
                        } else if !viewModel.areas.flatMap({$0.goals}).map({$0.name.lowercased()}).contains(goalName.lowercased()) {
                            viewModel.addGoalToArea(area: area, name: goalName)
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
                          title: SameNameError.TitleText.goal.rawValue,
                          message: SameNameError.MessageText.goal.rawValue,
                          dismissButton: SameNameError.DismissButtonText.goal.rawValue)
            EmptyNameError(isEmptyName: $isEmptyName,
                           title: EmptyNameError.TitleText.goal.rawValue,
                           message: EmptyNameError.MessageText.goal.rawValue,
                           dismissButton: EmptyNameError.DismissButtonText.goal.rawValue)
        }
    }
}
