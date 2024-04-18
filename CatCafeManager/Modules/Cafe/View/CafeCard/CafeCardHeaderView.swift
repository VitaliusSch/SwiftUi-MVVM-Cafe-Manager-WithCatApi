//
//  CafeCardHeaderView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 20.06.2023.
//

import Foundation
import SwiftUI
import Combine

struct CafeCardHeaderView: View {
    @StateObject var cafeViewModel = AppFactory.shared.resolve(CafeViewModel.self)
    
    var body: some View {
        HStack {
            VStack {
                ImageView(
                    size: 150,
                    circleShape: true,
                    imageUrl: cafeViewModel.selectedCafe.imageURL,
                    needRefresh: cafeViewModel.needRefreshPhoto
                )
                if !cafeViewModel.selectedCafe.title.isEmpty {
                    Button(
                        action: cafeViewModel.showCameraToAvatar,
                        label: {
                            Text("TakePhoto")
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
