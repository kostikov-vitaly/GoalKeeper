//
//  AreaView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct AreaView: View {
    
    @Binding var area: Area
    
    @EnvironmentObject var appTheme: AppTheme
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isPresented_Area_AddGoal: Bool = false
    @State var isManyGoals: Bool = false
    var isFirst: Bool {
        area.goals.count == 0
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Color("WhiteBlack")
                    .ignoresSafeArea(edges: .all)
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        backButton
                        Spacer()
                        Text(area.name)
                            .modifier(Prime_Title())
                            .lineLimit(1)
                        Spacer()
                        if isFirst {
                            emptyTrailingNavSpace
                        } else {
                            AddGoalButton(isModal: $isPresented_Area_AddGoal, area: $area)
                        }
                    }
                    
                    Section(content: { ListView(isActive: true, area: $area, isManyGoals: $isManyGoals).frame(minWidth: 160) }, header: {
                        viewModel.areas[viewModel.findAreaIndex(area: area)].goals.filter( {$0.isActive == true }).count >= 1 ?
                        HStack(alignment: .center) {
                            Text("Active")
                                .modifier(Prime_Title())
                                .foregroundColor(Color("BlackWhite"))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 10)
                        :
                        nil
                    })
                    
                    Section(content: { ListView(isActive: false, area: $area, isManyGoals: $isManyGoals).frame(height: 220) }, header: {
                        viewModel.areas[viewModel.findAreaIndex(area: area)].goals.filter( {$0.isActive == false }).count >= 1 ?
                        HStack(alignment: .center) {
                            Text("Inactive")
                                .modifier(Prime_Title())
                                .foregroundColor(Color("BlackWhite"))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        :
                        nil
                    })
                    
                    if isFirst {
                        AddFirstButton(isModal: $isPresented_Area_AddGoal, area: $area)
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
            .blur(radius: isManyGoals ? 10 : 0)
            .overlay(isManyGoals ? Color.black.opacity(0.35).ignoresSafeArea(.all) : nil)
            .disabled(isManyGoals)
            if isManyGoals {
                TooManyError(isError: $isManyGoals)
            }
        }
    }
}

extension AreaView {
    
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

extension AreaView {
    
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

extension AreaView {
    
    struct AddGoalButton: View {
        
        @Binding var isModal: Bool
        @Binding var area: Area
        
        var body: some View {
            Button(action: {
                isModal = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .light))
                    .frame(maxWidth: 32)
                    .foregroundColor(Color("BlackWhite"))
                    .padding()
                    .padding(.bottom, 8)
            }
            .sheet(isPresented: $isModal) { Area_AddGoal(area: $area) }
        }
    }
}

extension AreaView {
    
    struct AddFirstButton : View {
        
        @EnvironmentObject var appTheme: AppTheme
        @Binding var isModal: Bool
        @Binding var area: Area
        
        var body: some View {
            Button(action: {
                isModal = true
            }) {
                ZStack{
                    Color.accentColor
                    Text("Add your first goal")
                        .tracking(0.5)
                        .modifier(Rubik_Text_Bold())
                        .foregroundColor(.white)
                }
                .cornerRadius(10)
                .padding(.horizontal, appTheme.isSmall ? 14 : 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
            }
            .padding(.bottom, appTheme.isSmall ? 8 : 0)
            .sheet(isPresented: $isModal) { Area_AddGoal(area: $area) }
        }
    }
}

extension AreaView {
    
    struct ActivityButton: View {
        
        @EnvironmentObject var viewModel: ViewModel
        @Binding var goal: Goal
        @Binding var isManyGoals: Bool
        
        var body: some View {
            if goal.isActive {
                Button(action: {
                    let areaIndex = viewModel.findAreaIndex(goal: goal)
                    if viewModel.checkGoalsNumberWhenArchive(area: viewModel.areas[areaIndex]) {
                        isManyGoals = true
                    } else {
                        goal.isActive.toggle()
                    }
                }, label: {
                    Label("Deactivate", systemImage: "tray.and.arrow.down.fill")
                })
                    .tint(.gray)
            } else {
                Button(action: {
                    let areaIndex = viewModel.findAreaIndex(goal: goal)
                    if viewModel.checkGoalsNumberWhenReturn(area: viewModel.areas[areaIndex]) {
                        isManyGoals = true
                    } else {
                        goal.isActive.toggle()
                    }
                }, label: {
                    Label("Activate", systemImage: "tray.and.arrow.up.fill")
                })
                    .tint(.accentColor)
            }
        }
    }
}

extension AreaView {
    
    struct ListView: View {
        
        @EnvironmentObject var viewModel: ViewModel
        
        var isActive: Bool
        @Binding var area: Area
        @Binding var isManyGoals: Bool
        
        var body: some View {
            List {
                ForEach($area.goals, id: \.id) { $goal in
                    if goal.isActive == isActive {
                        if goal.isActive == true {
                            NavigationLink {
                                GoalView(goal: $goal)
                            } label: {
                                GoalRowView(goal: goal)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.removeGoal(area: area, goal: goal)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                ActivityButton(goal: $goal, isManyGoals: $isManyGoals)
                            }
                        } else {
                            GoalRowView(goal: goal)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.removeGoal(area: area, goal: goal)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    
                                    ActivityButton(goal: $goal, isManyGoals: $isManyGoals)
                                }
                        }
                    }
                }
                .listRowBackground(Color("WhiteBlack"))
            }
            .listStyle(.plain)
        }
    }
}
