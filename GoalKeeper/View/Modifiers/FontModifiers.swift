//
//  FontModifiers.swift
//  GoalKeeper
//
//  Created by Vitaly on 18/12/21.
//

import SwiftUI

struct Prime_Header: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Prime", size: 32))
    }
}

struct Prime_Title: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Prime", size: 21))
    }
}

struct Rubik_LargeText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Rubik Regular", size: 18))
            .lineSpacing(6)
    }
}


struct Rubik_Text_Bold: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Rubik Medium", size: 16))
            .lineSpacing(6)
            .opacity(0.9)
    }
}

struct Rubik_Text: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Rubik Regular", size: 16))
            .lineSpacing(4)
            .opacity(0.9)
    }
}

struct Rubik_Info: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Rubik Regular", size: 13))
            .lineSpacing(3)
    }
}
