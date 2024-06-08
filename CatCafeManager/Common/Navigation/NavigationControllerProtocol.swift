//
//  NavigationControllerProtocol.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 08.04.2024.
//

import SwiftUI

protocol NavigationControllerProtocol {
    /// Pushing a view like a NavigationLink, but holds the streamContinuation. This is the async emulation
    func pushViewGenericAsync<T>(
        view: some View,
        animated: Bool, // TODO: make default implementations: animated = true and others
        enableSwipeBack: Bool,
        title: String,
        titleHidden: Bool,
        defaultValue: T // TODO: make a push variant with a Result and a throws
    ) async -> T
    
    /// Pushing a view like a NavigationLink, but holds the CheckedContinuation. This is the async emulation
    func pushViewAsync(
        view: some View,
        animated: Bool,
        enableSwipeBack: Bool,
        title: String,
        titleHidden: Bool
    ) async
    
    /// This method pops the top view controller and resumes the CheckedContinuation. This is the async emulation
    func popViewAsync(animated: Bool)
    
    /// Pushing a view like a NavigationLink
    func pushView(
        view: some View,
        animated: Bool,
        enableSwipeBack: Bool,
        title: String,
        titleHidden: Bool
    )
    
    /// This method pops the top view controller, if it enabled in CustomHostingViewController
    func popView(animated: Bool)
    
    /// Pops the top view controller forced
    func popViewForce(animated: Bool)
    
    /// Presents View like a sheet
    func presentView(view: some View, animated: Bool)
    
    /// This method removes the top view controller
    func dismiss(animated: Bool)
}

// Defaults implementations
extension NavigationControllerProtocol {
    func pushViewAsync(
        view: some View,
        animated: Bool
    ) async {
        await self.pushViewAsync(
            view: view,
            animated: animated,
            enableSwipeBack: true,
            title: "",
            titleHidden: false
        )
    }
    func pushViewAsync(
        view: some View,
        animated: Bool,
        titleHidden: Bool
    ) async {
        await self.pushViewAsync(
            view: view,
            animated: animated,
            enableSwipeBack: true,
            title: "",
            titleHidden: titleHidden
        )
    }
    func popViewAsync() {
        self.popViewAsync(animated: true)
    }
}
