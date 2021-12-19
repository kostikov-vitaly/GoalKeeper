//
//  SameNameError.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct SameNameError: View {
    
    @Binding var isSameName: Bool
    let title: String
    let message: String
    let dismissButton: String
    
    enum TitleText: String {
        case goal = "Goal name error", task = "Task name error"
    }
    
    enum MessageText: String {
        case goal = "You already have the same named goal", task = "You already have the same named task"
    }
    
    enum DismissButtonText: String {
        case goal = "Change goal name", task = "Change task name"
    }
    
    var body: some View {
        if isSameName {
            ErrorAlert(shown: $isSameName,
                        title: Text(title),
                        message: Text(message),
                        dismissButton: Text(dismissButton))
        } else {
            EmptyView()
        }
    }
}
