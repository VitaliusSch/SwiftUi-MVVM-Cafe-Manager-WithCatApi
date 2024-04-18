//
//  CameraView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 10.01.2023.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraVM = AppFactory.shared.resolve(CameraViewModel.self)
    let givePhoto: (UIImage?) -> Void
    
    var body: some View {
        ZStack {
            CameraPreview(camera: cameraVM)
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

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraViewModel
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        DispatchQueue.main.async {
            camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
            camera.preview.frame = view.frame
            camera.preview.videoGravity = .resizeAspectFill
            view.layer.addSublayer(camera.preview)
            self.camera.session.startRunning()
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
