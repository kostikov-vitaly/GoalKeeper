//
//  ErrorAlert.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct ErrorAlert: View {
    
    @Binding var shown: Bool
    let title: Text
    let message: Text
    let dismissButton: Text
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 20) {
                VStack(alignment: .center, spacing: 16) {
                    title
                        .modifier(Prime_Title())
                        .foregroundColor(Color("Black"))
                    message
                        .tracking(0.5)
                        .modifier(Rubik_Text())
                        .foregroundColor(Color("Gray"))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 48)
                
                Divider()
                    .frame(maxHeight: 1)
                
                Button(action: {
                    shown.toggle()
                }) {
                    dismissButton
                        .tracking(0.5)
                        .modifier(Rubik_Text())
                        .frame(width: UIScreen.main.bounds.width - 40)
                }
            }
            .padding(.top, 8)
            .padding(.vertical, 20)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: UIScreen.main.bounds.width - 40)
    }
}

