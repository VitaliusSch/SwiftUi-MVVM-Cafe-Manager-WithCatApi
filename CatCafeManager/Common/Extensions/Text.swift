//
//  TextExtension.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 12.12.2022.
//

import SwiftUI

// A custom text field with a placeholder
// struct TextFieldWithPlaceholder: TextFieldStyle {
//    let placeholder: String
//    @Binding var text: String
//    var foregroundPHColor: Color
//
//    init(_ placeholder: String, text: Binding<String>, foregroundPHColor: Color = .placeholderText) {
//        self.placeholder = placeholder
//        self._text = text
//        self.foregroundPHColor = foregroundPHColor
//    }
//
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        ZStack(alignment: .leading) {
//            if text.isEmpty {
//                Text(NSLocalizedString(placeholder, comment: ""))
//                    .foregroundColor(foregroundPHColor)
//            }
//            configuration
//        }
//    }
// }
