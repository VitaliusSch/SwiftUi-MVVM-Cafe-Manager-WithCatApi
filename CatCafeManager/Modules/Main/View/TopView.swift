//
//  TopView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 28.02.2024.
//

import SwiftUI

struct TopView: View {
    @StateObject var moneyHolder = AppFactory.shared.resolve(MoneyHolderViewModel.self)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("YourMoney".withFormat(["\(moneyHolder.money)"]))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .font(.callout)
                .padding(5)
                .background(Color.systemGray4.opacity(0.7))
                .foregroundColor(.label)
                .cornerRadius(10)
            }
            Text("TapOnMapToNewCafe")
                .font(.callout)
                .padding(5)
                .background(Color.systemGray4.opacity(0.7))
                .foregroundColor(.label)
                .cornerRadius(10)
                .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
