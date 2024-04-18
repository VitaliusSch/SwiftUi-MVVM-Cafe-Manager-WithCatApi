//
//  CatCardView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 31.01.2024.
//

import Foundation
import SwiftUI

/// A cats adopt view
struct CatAdoptView: View {
    @StateObject var viewModel = AppFactory.shared.resolve(CatAdoptViewModel.self)
    var onCatSelect: (CatModel) -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.catList) { cat in
                        CatListCardView(cat: cat)
                            .onTapGesture {
                                onCatSelect(cat)
                            }
                            .onAppear {
                                Task { @MainActor in
                                    await viewModel.fetchCats(currentCat: cat)
                                }
                            }
                    }
                    if viewModel.isFetching {
                        ProgressView()
                            .padding(20)
                    }
                }
            }
            .navigationBarTitle(Text("SelectACat"), displayMode: .inline)
        }
        .task { @MainActor in
                await viewModel.fetchCats()
        }
    }
}
