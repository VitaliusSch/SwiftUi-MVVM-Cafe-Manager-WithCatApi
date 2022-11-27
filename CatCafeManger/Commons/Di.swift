//
//  Di.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import Foundation
import Swinject

class Di {
    static func setup(container: Container) {
        container.register(LocationManager.self) { _ in LocationManager() }
    }
}
