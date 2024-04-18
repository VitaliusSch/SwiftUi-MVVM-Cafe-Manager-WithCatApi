//
//  CameraSimulatorView.swift
//  CatCafeManager
//
//  Created by Mac on 27.02.2024.
//

import SwiftUI

/// Camera simulator
struct CameraSimulatorView: View {
    @StateObject var cameraVM = AppFactory.shared.resolve(CameraSimulatorViewModel.self)
    let givePhoto: (UIImage?) -> Void
    private var randomCatImage: UIImage?
    
    var body: some View {
        ZStack {
            ImageView(size: 400, imageUrl: cat.imageURL)
                .ignoresSafeArea()
            VStack {
                if cameraVM.isTaken {
                    HStack {
                        Spacer()
                        Button(
                            action: cameraVM.reTake,
                            label: {
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                        ).padding(.trailing, 10)
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    if cameraVM.isTaken {
                        Button(
                            action: {
                                givePhoto(cameraVM.getPhoto())
                            },
                            label: {
                                Text("Save")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 20)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                        ).padding(.leading)
                        Spacer()
                    } else {
                        Button(
                            action: cameraVM.takePhoto,
                            label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 65, height: 65, alignment: .center)
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 75, height: 75, alignment: .center)
                                }
                            }
                        )
                    }
                }.frame(height: 75)
            }
        }.onAppear(perform: {
            cameraVM.check()
        }).alert(isPresented: $cameraVM.alert) {
            Alert(title: Text("Enable camera"))
        }
    }
}
