//
//  DayCard.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct DayCard: View {
    
    var day: Day
    
    @EnvironmentObject private var appTheme: AppTheme
    
    var strokeColor: Color {
        appTheme.setDayCardMainColor(day: day)
    }
    var doneColor: Color {
        appTheme.setDayCardMainColor(day: day)
    }
    var undoneColor: Color {
        appTheme.setDayCardSecondColor(day: day)
    }
    var isLight: Bool {
        appTheme.appColorScheme == .light
    }
    
//    пройтись по всем таскам и глянуть сколько элементов соответствует текущему дню
//    var taskCount: Int {
//        day.taskCount
//    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(Color("WhiteBlack"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(strokeColor.opacity(isLight ? 0.6 : 0.8), lineWidth: 2))
                .padding(2)
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(day.unionText)
                        .font(.custom("Prime", size: 26))
                    Text("\(day.weekday)")
                        .tracking(1)
                        .font(.custom("Rubik Regular", size: 18))
                        .opacity(0.5)
                }
                .foregroundColor(Color("BlackWhite"))
                .padding(.top, 10)
                .padding(.bottom, 2)
                .padding(.horizontal, 24)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                        Text(String(Int.random(in: 1...15)))
                            .tracking(0.5)
                            .modifier(Rubik_Text_Bold())
                        Spacer()
                    }
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(doneColor)
                    .padding(.vertical, 4)
                    .padding(.leading, 10)
                    .padding(.trailing, 16)
                    .background(isLight ? doneColor.opacity(0.2) : Color("White").opacity(0.1))
                    .cornerRadius(10)
                    HStack(alignment: .center, spacing: 6) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                        Text(String(Int.random(in: 1...15)))
                            .tracking(0.5)
                            .modifier(Rubik_Text_Bold())
                        Spacer()
                    }
                    .frame(width: 80, alignment: .leading)
                    .foregroundColor(undoneColor)
                    .padding(.vertical, 4)
                    .padding(.leading, 10)
                    .padding(.trailing, 16)
                    .background(isLight ? undoneColor.opacity(0.2) : Color("White").opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.top, 12)
                .padding(.bottom, 8)
                .padding(.leading, 20)
                .foregroundColor(Color("WhiteBlack"))
            }
        }
        .frame(width: 168, height: 168, alignment: .leading)
    }
}
