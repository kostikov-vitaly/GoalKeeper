//
//  ContentView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct MainView: View {
    
    @Binding var areas: [Area]
    
    @EnvironmentObject private var viewModel: ViewModel
    @EnvironmentObject private var appTheme: AppTheme
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var days: [Day] = Day.loadingData
    @State private var isPresented_Main_AddGoal: Bool = false
    let saveAction: () -> Void
    
    var body: some View {
        ZStack {
            Color("WhiteBlack")
                .ignoresSafeArea(edges: .all)
            VStack(alignment: .leading, spacing: 0) {
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            Text("Good afternoon!")
                                .modifier(Prime_Header())
                            .padding(.top, 48)
                            Spacer()
                            Button(
                                action: {
                                    appTheme.chooseAppScheme()
                                },
                                label: {
                                    Image(systemName: "text.justify")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color("BlackWhite"))
                                })
                                .padding(.top, 20)
                        }
                        Text("Today, 19 December")
                            .font(.custom("Rubik Regular", size: 21))
                            .opacity(0.6)
                    }
                    .padding(.bottom, 24)
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                }
                
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach($days) { $day in
                                NavigationLink(destination: DayView(day: $day)) {
                                    DayCard(day: day)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                    }
                }
                
                Section {
                    Text("Areas of your life")
                        .modifier(Prime_Title())
                        .padding()
                        .padding(.leading, 4)
                    List($areas) { $area in
                        NavigationLink(destination: AreaView(area: $area)) {
                            AreaRowView(area: area)
                        }
                        .listRowBackground(Color("WhiteBlack"))
                    }
                    .listStyle(.plain)
                    .onChange(of: scenePhase) { phase in
                        if phase == .inactive {
                            saveAction()
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        isPresented_Main_AddGoal = true
                    }){
                        ZStack{
                            Color.accentColor
                            Text("Add new goal")
                                .tracking(0.5)
                                .modifier(Rubik_Text_Bold())
                                .foregroundColor(Color("White"))
                        }
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, maxHeight: 56)
                    }
                    .sheet(isPresented: $isPresented_Main_AddGoal) { Main_AddGoal() }
                }
            }
        }
    }
}
