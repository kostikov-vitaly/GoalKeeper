//
//  GoalRowView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct GoalRowView: View {
    
    var goal: Goal
    
    @EnvironmentObject var viewModel: ViewModel
    @EnvironmentObject var appTheme: AppTheme
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(goal.name)
                .modifier(Rubik_Text())
                .lineLimit(1)
                .foregroundColor(goal.isActive ? Color("BlackWhite") : .gray)
            Spacer()
            ZStack(alignment: .center) {
                Circle()
                    .fill(goal.isActive ? Color.accentColor : Color.gray)
                    .cornerRadius(32)
                    .frame(width: 32, alignment: .center)
                Text("\(goal.tasks.count)")
                    .modifier(Rubik_Text())
                    .foregroundColor(Color("White"))
            }
            .padding(.trailing, goal.isActive ? 4 : 24)
        }
        .modifier(Rubik_Text())
        .frame(height: appTheme.isSmall ? 34 : 40)
    }
}
