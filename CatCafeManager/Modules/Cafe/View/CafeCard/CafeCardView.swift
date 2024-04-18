//
//  CafeView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 12.12.2022.
//

import Foundation
import SwiftUI

/// A card of cafe
struct CafeCardView: View {
    @ObservedObject var cafeViewModel = AppFactory.shared.resolve(CafeViewModel.self)
    var body: some View {
        VStack {
            HStack {
                CafeCardHeaderView()
            }
            .modifier(modSectionStack)
            HStack {
                CafeCardInfoView(
                    cafe: $cafeViewModel.selectedCafe
                )
            }
            .modifier(modSectionStack)
            if !cafeViewModel.aNewCafe {
                HStack {
                    CatListView(
                        selectedCafe: cafeViewModel.selectedCafe
                    )
                    .padding(.horizontal, -10)
                }
                .modifier(modSectionStack)
            }
            Spacer()
        }
        .navigationBarTitle(Text("CafeInfo"), displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack {
                    Button(
                        action: {
                            Task {
                                await cafeViewModel.save()
                            }
                        }
                    ) {
                        Image(systemName: cafeViewModel.aNewCafe ? "checkmark.circle" : "xmark.circle")
                    }
                }
        )
    }
}
