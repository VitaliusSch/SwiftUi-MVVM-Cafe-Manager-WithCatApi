//
//  FontExtension.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 26.12.2022.
//

import SwiftUI

extension Font {
    static func appFont(size: CGFloat) -> Font {
        return Font.custom("Microsoft Sans Serif", size: size)
    }
    static let appFont22 = appFont(size: 22).weight(.medium)
    static let appFont20 = appFont(size: 20).weight(.medium)
}
