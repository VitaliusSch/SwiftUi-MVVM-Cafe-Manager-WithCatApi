//
//  TextViewEditorView.swift
//  CatCafeManager
//
//  Created by Mac on 03.06.2024.
//

import Foundation
import SwiftUI

struct TextViewEditorView: View {
    @Binding var comment: String
    var placeholderText: String = "EnterComment"
    var placeholderForegroundColor = Color.gray
    var fontStyle: UIFont.TextStyle = .headline
    var isEditable = true
    var backgroundColor = Color.systemGray2
    var foregroundColor = Color.label
    var onFocus: () -> Void = {}
    var onLostFocus: () -> Void = {}
    
    var body: some View {
        ZStack {
            TextView(
                text: $comment,
                fontStyle: fontStyle,
                isEditable: isEditable,
                backgroundColor: UIColor(backgroundColor),
                foregroundColor: UIColor(foregroundColor)
            )
            .modifier(TextEditorViewModifier(
                onFocus: onFocus,
                onLostFocus: onLostFocus,
                keyboardType: .default
            ))
            if comment.isEmpty {
                HStack {
                    Text(placeholderText)
                        .padding(.leading, 10)
                        .foregroundColor(placeholderForegroundColor)
                        .allowsHitTesting(false)
                    Spacer()
                }
            }
        }
    }
}
