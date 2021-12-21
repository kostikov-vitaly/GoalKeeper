//
//  GoalRowView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct GoalRowView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    var goal: Goal
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(goal.name)
                .modifier(Rubik_Text())
            Spacer()
            ZStack(alignment: .center) {
                Circle()
                    .fill(Color.accentColor)
                    .cornerRadius(32)
                    .frame(width: 32, alignment: .center)
                Text("\(goal.tasks.count)")
                    .modifier(Rubik_Text())
                    .foregroundColor(Color("White"))
            }
            .padding(.trailing, 4)
        }
        .modifier(Rubik_Text())
        .frame(minHeight: 40)
    }
}
