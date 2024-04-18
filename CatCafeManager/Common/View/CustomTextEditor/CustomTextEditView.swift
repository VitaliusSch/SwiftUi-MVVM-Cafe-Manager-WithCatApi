//
//  CustomTextEditView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 07.09.2023.
//

import SwiftUI

/// A custom text edit with the placeholder and the auto-expand feature
struct CustomTextEditView: View {
    @Binding var text: String
    @Binding var editing: Bool

    var backgroundColor = Color.cardBackColor
    var borderColor = Color.white
    var foregroundColor = Color.systemGray4
    var foregroundPlaceholderColor = Color.gray
    var maxCharactersErrorColor = Color.red
    var plaseholdeText: String = "EnterComment"
    var disabled = false
    var maxCharacters: Int = 1000
    var charactersInRow: Int = 40
    let onSubmit: (String) -> Void
    
    @FocusState internal var edit: Bool
    @State private var wordCount: Int = 0
    @State internal var showError = false

    var body: some View {
        if disabled {
            CollapsedTextView(text: text, backgroundColor: backgroundColor, foregroundColor: foregroundPlaceholderColor)
                .padding(.top, 5)
        } else {
            ZStack(alignment: .leading) {
                if #available(iOS 16.0, *) {
                    editorView()
                        .scrollContentBackground(.hidden)
                } else {
                    editorView()
                }
                placeHolderView()
            }
            .cornerRadius(5)
            .padding(2)
            .background(backgroundColor)
            .cornerRadius(5)
            .padding(-2)
            .background(borderColor)
            .onTapGesture {
                edit = true
            }
// TODO: if need MaxCharacterError
//            .alert(NSLocalizedString("MaxCharacterError", comment: "").withFormat(value: "\(maxCharacters)"), isPresented: $showError) {
//                Button("Ok", role: .none) { }
//            }
        }
    }
}
