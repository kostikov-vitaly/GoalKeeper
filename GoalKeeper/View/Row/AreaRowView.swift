//
//  AreaRowView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct AreaRowView: View {
    
    @EnvironmentObject var appTheme: AppTheme
    
    var area: Area
    
    var body: some View {
        HStack {
            Text(area.emoji)
                .padding(.trailing, 4)
            Text(area.name)
                .tracking(0.5)
                .modifier(Rubik_Text())
            Spacer()
        }
        .frame(height: appTheme.isSmall ? 34 : 36)
    }
}
