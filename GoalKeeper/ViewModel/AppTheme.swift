//
//  Theme.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

class AppTheme: ObservableObject {
    
    @Published var appColorScheme: ColorScheme? = .light
    @Published var isSmall: Bool = UIScreen.main.bounds.height < 800
    @Published var ActiveButtonColor: [String: Color] = ["fill": Color("AccentWhite"), "color": Color("WhiteBlack")]
    @Published var InactiveButtonColor: [String: Color] = ["fill": Color("BlackWhite").opacity(0.1), "color": Color("BlackWhite").opacity(0.5)]
    
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
