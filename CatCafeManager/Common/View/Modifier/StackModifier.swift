//
//  StackExtention.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import SwiftUI

let modCardStack = CardStack()
struct CardStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.systemGray4)
            .cornerRadius(10)
            .padding(.horizontal, 10)
    }
}

let modSectionStack = SectionStack()
struct SectionStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.systemGray6)
            .cornerRadius(10)
            .padding(.horizontal, 10)
    }
}

let modBackStack = BackStack()
struct BackStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(Color.systemGray5)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

let modTextEditor = TextEditorMod()
struct TextEditorMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.systemGray4)
            .foregroundColor(.gray)
            .cornerRadius(10)
            .padding(.horizontal, 10)
    }
}
