//
//  DayView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct DayView: View {
    
    @Binding var day: Day
    
    @Environment(\.dismiss) var dismiss
    
    @GestureState var dragOffset = CGSize.zero
    
    var body: some View {
        
        ZStack {
            Color("WhiteBlack")
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    backButton
                    Spacer()
                    Text(day.unionText)
                        .modifier(Prime_Title())
                    Spacer()
                    emptyTrailingNavSpace
                }
                
                List {
                    Text("123")
                        .tracking(0.5)
                        .listRowBackground(Color("WhiteBlack"))
                    Text("123")
                        .tracking(0.5)
                        .listRowBackground(Color("WhiteBlack"))
                    Text("123")
                        .tracking(0.5)
                        .listRowBackground(Color("WhiteBlack"))
                    Text("123")
                        .tracking(0.5)
                        .listRowBackground(Color("WhiteBlack"))
                }
                .modifier(Rubik_Text())
                .listStyle(.plain)
            }
        }
        .navigationBarHidden(true)
        .modifier(BackGesture(dragOffset: dragOffset))
        
    }
}

extension DayView {
    
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

extension DayView {
    
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
