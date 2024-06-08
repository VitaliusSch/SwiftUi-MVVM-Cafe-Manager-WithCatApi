//
//  File.swift
//  CatCafeManager
//
//  Created by Mac on 03.06.2024.
//

import SwiftUI

struct TextEditorViewModifier: ViewModifier {
    @FocusState private var focus: Bool
    var onFocus: () -> Void = {}
    var onLostFocus: () -> Void = {}
    var backgroundColor = Color.systemGray3
    var keyboardType: UIKeyboardType = .default
    
    func body(content: Content) -> some View {
        content
            .keyboardType(keyboardType)
            .padding(.all, 6)
            .background(backgroundColor)
            .cornerRadius(6)
            .padding(.all, 2)
            .background(Color.gray)
            .cornerRadius(8)
            .focused($focus)
            .foregroundColor(backgroundColor)
            .onChange(of: focus) { newFocus in
                if newFocus {
                    onFocus()
                    // TODO: animation via property
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        UIView.setAnimationsEnabled(false)
                    }
                    // TODO: autoselect all text after focus
                    //                    DispatchQueue.main.async {
                    //                        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                    //                    }
                } else {
                    onLostFocus()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        UIView.setAnimationsEnabled(true)
                    }
                    // TODO: keyboard off
                    //                    DispatchQueue.main.async {
                    //                    Task { @MainActor in
                    //                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    //                    }
                }
            }
            .autocorrectionDisabled()
    }
}
