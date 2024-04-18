//
//  CatListView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 23.03.2023.
//

import Foundation
import SwiftUI

struct CatListView: View {
    @ObservedObject var viewModel = AppFactory.shared.resolve(CatListViewModel.self)
    var selectedCafe: CafeModel

    var body: some View {
        VStack {
            buttonView()
            ScrollView {
                ForEach(viewModel.cats) { cat in
                    CatListCardView(cat: cat)
                }
            }
        }
        .task {
            await viewModel.setCafe(cafe: selectedCafe)
        }
    }
    
    @ViewBuilder
    func buttonView() -> some View {
        HStack {
            HStack {
                Image(systemName: "plus.circle")
                Text("CatAddNew")
                    .frame(maxWidth: .infinity)
            }
            .onTapGesture {
                Task {
                    await viewModel.adoptCat()
                }
            }
        }
        .padding(.horizontal, 20)
        .modifier(modCardStack)
        .padding(.top, 5)
    }
}
