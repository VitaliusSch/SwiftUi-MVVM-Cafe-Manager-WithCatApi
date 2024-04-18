//
//  CollapsedTextView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 07.09.2023.
//

import SwiftUI

/// Collapsed text view
///  Tap on the text and it will be expanded
struct CollapsedTextView: View {
    @State var text: String
    var backgroundColor = Color.cardBackColor
    var foregroundColor = Color.systemGray4
    @State private var collapsed = true

    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(collapsed ? 2 : 200)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .multilineTextAlignment(.leading)
            .onTapGesture {
                collapsed.toggle()
            }
    }
}
