//
//  CatCafeMangerApp.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import SwiftUI
import Swinject

var sinjectContainer: Container!

@main
struct CatCafeMangerApp: App {
    
    init() {
        sinjectContainer = Container()
        Di.setup(container: sinjectContainer)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
