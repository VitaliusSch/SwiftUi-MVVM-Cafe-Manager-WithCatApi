//
//  ImageView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import SwiftUI
import Combine

private enum ImageState {
    case start
    case loading
    case error
    case gotImage(UIImage)
}

struct ImageView: View {
    var imageRepo = AppFactory.shared.resolve(ImageRepository.self)
    let size: Double
    var circleShape = false
    var imageUrl: URL?
    @State private var imageState: ImageState = .start
    var needRefresh = PassthroughSubject<Bool, Never>()
    
    var body: some View {
        VStack(alignment: .center) {
            switch imageState {
            case .start:
                Image(systemName: "nosign")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size/2, height: size/2)
            case .loading:
                ProgressView()
                    .tint(.gray)
            case .gotImage(let image):
                if circleShape {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .cornerRadius(size/10.0)
                }
            case .error:
                Image(systemName: "photo.artframe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size/2, height: size/2)
            }
        }
        .frame(width: size, height: size)
        .onReceive(
            needRefresh,
            perform: { value in
                if value {
                    Task() {
                        await setImage()
                    }
                }
            }
        )
        .task {
            await setImage()
        }
    }
    
    @MainActor func setImage() async {
        imageState = .loading
        if let imageAwaited = await imageRepo.loadImage(url: imageUrl) {
            imageState = .gotImage(imageAwaited)
        } else {
            imageState = .error
        }
    }
}
