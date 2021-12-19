//
//  DayView.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct DayView: View {
    
    @Binding var day: Day
    
    var body: some View {
        Text(day.unionText)
    }
}
