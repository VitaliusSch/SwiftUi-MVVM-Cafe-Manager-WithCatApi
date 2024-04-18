//
//  GridView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 01.12.2022.
//
//  From Apple's examples :)
//

import Foundation
import SwiftUI

/// Presents list of images as the grid
struct GridView: View {
    private static let initialColumns = 3

    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @State var imageIds: [String]
    
    let getImage: (String) async -> UIImage
    
    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(imageIds, id: \.self) { item in
                GeometryReader { geo in
                    NavigationLink(destination:
                        DetailGridItemView() {
                            await self.getImage(item)
                        }.navigationBarTitleDisplayMode(.inline)
                    ) {
                        GridItemView(size: geo.size.width) {
                            await self.getImage(item)
                        }
                    }
                }
                .cornerRadius(8.0)
                .aspectRatio(1, contentMode: .fit)
            }
        }
        .padding()
    }
}

struct GridItemView: View {
    let size: Double
    @State private var image: UIImage?
    let getImage: () async -> UIImage
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if self.image == nil {
                ProgressView()
                    .tint(.gray)
            } else {
                Image(uiImage: self.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
            }
        }
        .frame(width: size, height: size)
        .task(priority: .background, {
            if self.image == nil {
                self.image = await getImage()
            }
        })
    }
}

struct DetailGridItemView: View {
    @State private var image: UIImage?
    let getImage: () async -> UIImage
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if self.image == nil {
                ProgressView()
                    .tint(.gray)
            } else {
                Image(uiImage: self.image!)
                    .resizable()
                    .scaledToFill()
            }
        }
        .task(priority: .background, {
            if self.image == nil {
                self.image = await getImage()
            }
        })
    }
}
