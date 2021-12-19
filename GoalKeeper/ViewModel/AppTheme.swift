//
//  Theme.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

class AppTheme: ObservableObject {
    
    @Published var appColorScheme: ColorScheme? = .light
    
    func chooseAppScheme() {
        appColorScheme = appColorScheme == .light ? .dark : .light
    }
    
    var isLight: Bool {
        appColorScheme == .light
    }
    
    func setDayCardMainColor(day: Day) -> Color {

        let color: Color
        if ViewModel().isToday(day: day) {
            color = .accentColor
        } else {
            color = .gray
        }
        return color
    }
    
    func setDayCardSecondColor(day: Day) -> Color {
        
        let color: Color
        if ViewModel().isToday(day: day) {
            color = .red
        } else {
            color = .gray
        }
        return color
    }
}
