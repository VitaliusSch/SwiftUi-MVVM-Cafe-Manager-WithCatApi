//
//  CafeCartView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 23.12.2022.
//

import Foundation
import SwiftUI

struct CafeListCardView: View {
    var cafe: CafeModel
    
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(cafe.title)")
                .frame(maxWidth: .infinity)
            HStack {
                ImageView(size: 50, imageUrl: cafe.imageURL)
                CafeLocationView(cafe: cafe)
            }
        }
        .padding(.horizontal, 20)
        .modifier(modCardStack)
    }
}
