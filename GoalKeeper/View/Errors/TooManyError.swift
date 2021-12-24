//
//  TooMuchActiveError.swift
//  GoalKeeper
//
//  Created by Vitaly on 23/12/21.
//

import SwiftUI

struct TooManyError: View {
    
    @Binding var isError: Bool
    let title: String = "Too many goals"
    let message: String = "You can't have more than 5 active and 4 inactive goals in an area"
    let dismissButton: String = "Ok"
    
    var body: some View {
        if isError {
            ErrorAlert(shown: $isError, title: Text(title), message: Text(message), dismissButton: Text(dismissButton))
        } else {
            EmptyView()
        }
    }
}

