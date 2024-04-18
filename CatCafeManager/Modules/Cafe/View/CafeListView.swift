//
//  CafeListView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 23.12.2022.
//

import Foundation
import SwiftUI

struct CafeListView: View {
    @ObservedObject var viewModel: CafeViewModel
    @State private var expanded = false
    @State private var yTranslation: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            VStack {
                buttonView()
                searchStringView()
                ScrollView {
                    ForEach(viewModel.cafes) { cafe in
                        CafeListCardView(cafe: cafe)
                            .onTapGesture {
                                viewModel.showCafeCardView(cafeToSelect: cafe)
                            }
                    }
                }
            }
            .modifier(modBackStack)
            .offset(x: 0, y: geo.size.height - (expanded ? geo.size.height / 1.7 : 80))
            .offset(x: 0, y: self.yTranslation)
            .frame(width: geo.size.width, height: geo.size.height - (expanded ? geo.size.height / 2.6 : 80))
            .animation(.spring(), value: self.expanded)
            .gesture(
                DragGesture().onChanged { value in
                    self.yTranslation = value.translation.height
                }.onEnded { value in
                    self.expanded = (value.translation.height < -20)
                    self.yTranslation = 0
                    if !expanded {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            )
            .onTapGesture {
                self.expanded.toggle()
            }
        }
    }
    
    @ViewBuilder
    func buttonView() -> some View {
        HStack(alignment: .center) {
            Rectangle()
                .frame(width: 50, height: 5, alignment: .center)
                .cornerRadius(10)
                .opacity(0.25)
                .padding(.vertical, 10)
        }
    }
    @ViewBuilder
    func searchStringView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("", text: $viewModel.searchText, prompt: Text("TypeToSearch").foregroundColor(.gray))
                .frame(minWidth: 30)
                .foregroundColor(.darkText)
                .onTapGesture {
                    self.expanded = true
                }
        }
        .modifier(modTextEditor)
    }
}
