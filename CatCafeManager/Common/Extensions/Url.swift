//
//  UrlExtension.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import Foundation
import SwiftUI

// URL image helpers
extension URL {
    private var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(self.pathExtension)
    }
}
