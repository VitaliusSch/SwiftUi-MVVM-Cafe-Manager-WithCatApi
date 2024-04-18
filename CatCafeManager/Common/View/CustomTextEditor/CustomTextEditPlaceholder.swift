//
//  PlaceHolderView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 08.09.2023.
//

import SwiftUI

extension CustomTextEditView {
    @ViewBuilder
    func placeHolderView() -> some View {
        if text.isEmpty {
           VStack {
                Text(NSLocalizedString(plaseholdeText, comment: ""))
                   .foregroundColor(foregroundPlaceholderColor)
                   .frame(height: 30)
                   .padding(.horizontal, 10)
                   .padding(.bottom, 12)
                   .background(.white.opacity(0.01))
                   .opacity(0.3)
           }
           .background(.white.opacity(0.01))
           .onTapGesture {
               edit = true
           }
        }
    }
}
