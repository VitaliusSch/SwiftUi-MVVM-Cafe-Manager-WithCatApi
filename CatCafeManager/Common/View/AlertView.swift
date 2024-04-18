//
//  AlertView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 05.02.2024.
//

import SwiftUI

struct AlertView: View {
    var message: String
    var navigation = AppFactory.shared.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)
   
    var body: some View {
        ZStack {
            VStack {
                Text(NSLocalizedString("\(message)", comment: ""))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.system(size: 24).bold())
                    .multilineTextAlignment(.center)
                    .padding(10)
                Divider()
                HStack {
                    Button {
                        navigation.popView(animated: false)
                    } label: {
                        Text("Ok")
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 10)
            }
            .background(Color.systemGray5)
            .cornerRadius(12)
            .padding(.vertical, 100)
            .padding(.horizontal, 20)
            .font(.system(size: 24))
        }
    }
}
