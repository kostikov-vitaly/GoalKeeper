//
//  AppViewModifiers.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct BackGesture: ViewModifier {
    
    @GestureState var dragOffset: CGSize
    @Environment(\.dismiss) var dismiss
    
    func body(content: Content) -> some View {
        content
            .gesture(DragGesture().updating($dragOffset, body: { (value, state, transition) in
                if (value.startLocation.x < 50 && value.translation.width > 100) {
                    dismiss()
                }
            }))
    }
}
