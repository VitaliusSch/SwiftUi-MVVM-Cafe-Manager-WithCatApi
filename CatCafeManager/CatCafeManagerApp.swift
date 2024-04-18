//
//  CatCafeMangerApp.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import SwiftUI
import Swinject

@main
struct CatCafeManagerApp: App {
    private var navigation: CustomNavigationController
    init() {
        // Init App, setUp DI
        AppFactory.shared.setUp(customContainer: nil)
        // Main navigation controller. You can add another navigation: just resolve CustomNavigationController with another name!
        navigation = AppFactory.shared.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)
    }
    
    var body: some Scene {
        WindowGroup {
            CustomControllerRepresentable(
                nav: navigation,
                rootView: MainView()
            )
        }
    }
}
