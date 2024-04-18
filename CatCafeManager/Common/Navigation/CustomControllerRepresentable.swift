//
//  CustomNavigationController.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 28.09.2023.
//

import SwiftUI

/// A custom navigation top level generic controller to the programmatically navigation
struct CustomControllerRepresentable<T: View>: UIViewControllerRepresentable {
    private let nav: CustomNavigationController
    private let rootView: T
    
    init(nav: CustomNavigationController, rootView: T) {
        self.nav = nav
        self.rootView = rootView
    }

    func makeUIViewController(context: Context) -> CustomNavigationController {
        let vc = UIHostingController(rootView: rootView)
        nav.addChild(vc)
        return nav
    }

    func updateUIViewController(_ pageViewController: CustomNavigationController, context: Context) {
    }
}
