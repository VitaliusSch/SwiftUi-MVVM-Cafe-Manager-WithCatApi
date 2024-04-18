//
//  CustomTextEditor.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 08.09.2023.
//

import SwiftUI

extension CustomTextEditView {
    private func textHeight() -> CGFloat {
        if (text.isEmpty || text.count < charactersInRow) && (!text.contains("\n")) {
            return 30
        } else {
            return 120
        }
    }
    @ViewBuilder
    func editorView() -> some View {
        VStack {
            TextEditor(text: $text)
                .foregroundColor(foregroundColor)
                .background(Color.white)
                .disableAutocorrection(true)
                .focused($edit)
                .onChange(of: edit) { newFocus in
                    editing = newFocus
                    if !newFocus {
                        onSubmit(
                            text.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    }
                }
                .onChange(of: text) { value in
                    if value.count > maxCharacters {
                        text = String(text.prefix(maxCharacters))
                        showError = true
                    }
                }
                .frame(height: textHeight())
                .disabled(disabled)
                .overlay {
                    if !text.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .foregroundColor(.secondary)
                            .padding(.trailing, 4)
                        }
                    }
                }
            // TODO: world count               .onChange(of: text) { value in
            //                    let words = text.split { $0 == " " || $0.isNewline }
            //                    self.wordCount = words.count
            //                }
            // .lineSpacing(20)
            HStack {
                Spacer()
                Text(verbatim: "\(text.count)/\(maxCharacters)")
                    .font(.caption)
                    .foregroundColor(text.count <= maxCharacters ? foregroundColor : maxCharactersErrorColor )
            }
            .frame(height: 10)
            .padding(1)
        }
        .background(.white)
    }
}
