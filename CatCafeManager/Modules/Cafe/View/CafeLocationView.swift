//
//  CafelocationView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 13.03.2024.
//

import SwiftUI

/// Information about cafe location
struct CafeLocationView: View {
    var cafe: CafeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Coordinates")
                    .foregroundColor(.gray)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text("Latitude")
                        .foregroundColor(.gray)
                    Text(" \(cafe.latitude)")
                }
                HStack {
                    Text("Longitude")
                        .foregroundColor(.gray)
                    Text(" \(cafe.longitude)")
                }
            }
            .padding(.leading, 30)
        }
    }
}
