//
//  GalleryView.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 09.03.2023.
//

import Foundation
import SwiftUI

/// Allows to view images in the gallery style
struct GalleryView: View {
    @Environment(\.dismiss)
    private var dismiss
    @State private var imageIds: [String] = []
    @State private var currentImageId: String
    let getImage: (String) async -> UIImage
    @State private var images: [UIImage] = []
    @State private var image: UIImage?
    @State private var forwards = false
    var currentImageIdx: Int {
        if let idx = self.images.firstIndex(where: { $0 == image }) {
            return idx
        }
        return 0
    }
    // body
    var body: some View {
        ZStack {
            Color
                .gray
                .ignoresSafeArea(.all)
            VStack(alignment: .center) {
                headerDetailView()
                carouselView()
            }
        }
    }
    // Header Detail View
    @ViewBuilder
    func headerDetailView() -> some View {
        ZStack(alignment: .topTrailing) {
            if self.image == nil {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 300)
                    .foregroundColor(.white)
                    .tint(.gray)
            } else {
                GeometryReader { proxy in
                    HStack {
                        Spacer()
                        Text("\(currentImageIdx + 1)")
                        Text("/")
                        Text("\(images.count)")
                        Spacer()
                    }
                    if let img = self.image {
                        Image(uiImage: img )
                            .resizable()
                            .scaledToFit()
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: forwards ? .trailing : .leading),
                                    removal: .move(edge: forwards ? .leading : .trailing)
                                )
                            )
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .clipShape(Rectangle())
// TODO: for PAN .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                            .scaleEffect(self.magScale * progressingScale)
                            .gesture(
                                magnification
                            )
                    }
                }
            }
        }
        .task(priority: .background, {
            for imageId in imageIds {
                let img = await self.getImage(imageId)
                self.images.append(img)
                if currentImageId == imageId {
                    self.image = img
                }
            }
        })
        .gesture(
            dragGesture
        )
    }
    // Carousel View
    @ViewBuilder
    func carouselView() -> some View {
        ZStack {
            if images.isEmpty {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(images.indices, id: \.self) { imageIdx in
                                Button(
                                    action: {
                                        withAnimation {
                                            self.image = images[imageIdx]
                                        }
                                    }
                                ) {
                                    GridItemView(size: self.image == images[imageIdx] ? 80 : 60) {
                                        let imageFromList = self.images[imageIdx]
                                        return await self.getImageFormList(image: imageFromList)
                                    }
                                }
                                .cornerRadius(8.0)
                                .aspectRatio(1, contentMode: .fit)
                                .id(imageIdx)
                            }
                        }
                    }.onChange(of: image) { _ in
                        withAnimation {
                            proxy.scrollTo(currentImageIdx, anchor: .top)
                        }
                    }
                }
            }
        }
    }
    // getImageFormList
    func getImageFormList(image: UIImage) async -> UIImage {
        return image
    }
    // dragGesture
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.width < -10 {
                                forwards = true
                                withAnimation {
                                    loadImage()
                                }
                            }

                            if value.translation.width > 10 {
                                forwards = false
                                withAnimation {
                                    loadImage()
                                }
                            }
                            if value.translation.height < -250 {
                                dismiss()
                            }

                            if value.translation.height > 250 {
                                dismiss()
                            }
                        })
    }

    func loadImage() {
        if let idx = self.images.firstIndex(where: {$0 == image }) {
            if idx < self.images.count - 1 && self.forwards {
                withAnimation {
                    image = self.images[idx + 1]
                }
            }
            if idx > 0 && !self.forwards {
                withAnimation {
                    image = self.images[idx - 1]
                }
            }
        }
    }
    // magnification
    @State var magScale: CGFloat = 1
    @State var progressingScale: CGFloat = 1
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged {
                progressingScale = $0
            }
            .onEnded {
                magScale *= $0
                if magScale < 1 {
                    magScale = 1
                }
                progressingScale = 1
            }
    }
}
