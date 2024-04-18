//
//  TextFieldView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 27.02.2023.
//

import Foundation
import SwiftUI

struct TextFieldWithSubmitView: View {
    @Binding var text: String
    var plaseholdeText: String = "TypeAnything"
    var disabled = false
    let onSubmit: (String) -> Void
    
    @FocusState private var edit: Bool
    
    var body: some View {
        TextField("", text: $text, prompt: Text(plaseholdeText).foregroundColor(.gray))
            .disabled(disabled)
            .onChange(of: edit) { newFocus in
                if !newFocus {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    onSubmit(text.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
    }
}

struct TextFieldView: View {
    @Binding var text: String
    var plaseholdeText: String = "TypeAnything"
    var disabled = false
    
    @FocusState private var edit: Bool
    
    var body: some View {
        TextField("", text: $text, prompt: Text(NSLocalizedString(plaseholdeText, comment: "") ).foregroundColor(.gray))
            .disabled(disabled)
            .onChange(of: edit) { newFocus in
                if !newFocus {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
    }
}
