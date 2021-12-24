//
//  EmptyError.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct EmptyNameError: View {
    
    @Binding var isError: Bool
    let title: String
    let message: String
    let dismissButton: String
    
    enum TitleText: String {
        case goal = "Goal name error", task = "Task name error"
    }
    
    enum MessageText: String {
        case goal = "Name of this goal shouldn't ever be empty", task = "Name of this task shouldn't ever be empty"
    }
    
    enum DismissButtonText: String {
        case goal = "Change goal name", task = "Change task name"
    }
    
    var body: some View {
        if isError {
            ErrorAlert(shown: $isError, title: Text(title), message: Text(message), dismissButton: Text(dismissButton))
        } else {
            EmptyView()
        }
    }
}
