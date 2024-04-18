//
//  CatCardView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 23.03.2023.
//

import Foundation
import SwiftUI

struct CatListCardView: View {
    var cat: CatModel
    
    var body: some View {
        HStack {
            ImageView(size: 50, imageUrl: cat.imageURL)
            VStack(alignment: .center) {
                HStack {
                    Text("Name")
                        .frame(width: 100, alignment: .leading)
                    Text("\(cat.nameWrapped)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                HStack {
                    Text("Cost")
                        .frame(width: 100, alignment: .leading)
                    Text("\(cat.adoptCostWrapped)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 5)
        .modifier(modCardStack)
    }
}
