//
//  AreaView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct AreaView: View {
    
    @Binding var area: Area
    
    @EnvironmentObject private var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var isPresented_Area_AddGoal: Bool = false
    var isFirst: Bool {
        area.goals.count == 0
    }
    
    var body: some View {
        ZStack {
            Color("WhiteBlack")
                .ignoresSafeArea(edges: .all)
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    backButton
                    Spacer()
                    Text(area.name)
                        .modifier(Prime_Title())
                    Spacer()
                    if isFirst {
                        emptyTrailingNavSpace
                    } else {
                        AddGoalButton(isModal: $isPresented_Area_AddGoal, area: $area)
                    }
                }
                
                List {
                    ForEach($area.goals, id: \.id) { $goal in
                        NavigationLink {
                            GoalView(goal: $goal)
                        } label: {
                            GoalRowView(goal: goal)
                        }
                    }
                    .onDelete { i in
                        viewModel.removeGoal(area: area, item: i)
                    }
                    .listRowBackground(Color("WhiteBlack"))
                }
                .listStyle(.plain)
                
                if isFirst {
                    AddFirstButton(isModal: $isPresented_Area_AddGoal, area: $area)
                } else {
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
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
                        .foregroundColor(Color("White"))
                }
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: 56)
            }
            .sheet(isPresented: $isModal) { Area_AddGoal(area: $area) }
        }
    }
}
