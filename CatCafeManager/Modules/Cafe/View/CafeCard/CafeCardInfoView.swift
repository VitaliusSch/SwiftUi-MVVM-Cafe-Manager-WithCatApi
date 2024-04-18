//
//  CafeCardInfoView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 20.06.2023.
//

import Foundation
import SwiftUI

/// Information about a cafe
struct CafeCardInfoView: View {
    @Binding var cafe: CafeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "square.and.pencil")
                TextFieldView(text: $cafe.title, plaseholdeText: "EnterNewCafeTitle")
            }
            CafeLocationView(cafe: cafe)
        }
    }
}
