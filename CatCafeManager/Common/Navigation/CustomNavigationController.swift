//
//  CustomNavigationController.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 18.12.2023.
//

import UIKit
import SwiftUI

/// Custom UINavigationController
final class CustomNavigationController: UINavigationController, NavigationControllerProtocol {
    /// Pushing a view like a NavigationLink, but holds the CheckedContinuation. This is the async emulation
    /// - Parameters:
    ///   - view: The view to display over the current view controller’s content
    ///   - animated: Pass true to animate the presentation
    func pushViewAsync(
        view: some View,
        animated: Bool = true,
        enableSwipeBack: Bool = true,
        title: String = "",
        titleHidden: Bool = false
    ) async {
        await withCheckedContinuation { continuation in
            self.pushViewController(
                CustomHostingController(
                    rootView: view,
                    navigationBarTitle: title,
                    navigationBarHidden: titleHidden,
                    enableSwipeBack: enableSwipeBack,
                    checkContinuation: continuation
                ),
                animated: animated
            )
        }
    }
    /// Pushing a view like a NavigationLink, but holds the CheckedContinuation. This is the async emulation
    /// - Parameters:
    ///   - view: The view to display over the current view controller’s content
    ///   - animated: Pass true to animate the presentation
    func pushViewGenericAsync<T>(
        view: some View,
        animated: Bool = true,
        enableSwipeBack: Bool = true,
        title: String = "",
        titleHidden: Bool = false,
        defaultValue: T
    ) async -> T {
        var returnedValue: T = defaultValue
        let returnedStream = AsyncStream<T> { continuation in
            self.pushViewController(
                GenericHostingController(
                    view: view,
                    navigationBarTitle: title,
                    navigationBarHidden: titleHidden,
                    enableSwipeBack: enableSwipeBack,
                    streamContinuation: continuation,
                    navigation: self
                ),
                animated: animated
            )
        }
        
        for await dd in returnedStream {
            returnedValue = dd
        }
        
        return returnedValue
    }

    /// This method pops the top view controller and resumes the CheckedContinuation. This is the async emulation
    /// - Parameter animated: Set this value to true to animate the transition or the presentation
    func popViewAsync(animated: Bool = true) {
        _ = self.popViewController(animated: animated)
    }
    
    /// Pushing a view like a NavigationLink
    /// - Parameters:
    ///   - view: A view to push onto the stack
    ///   - animated: Specify true to animate the transition or false
    ///   - swipeBackEnabled: Enables or disables swipe back
    func pushView(
        view: some View,
        animated: Bool = true,
        enableSwipeBack: Bool = true,
        title: String = "",
        titleHidden: Bool = false
    ) {
        self.pushViewController(
            CustomHostingController(
                rootView: view,
                navigationBarTitle: title,
                navigationBarHidden: titleHidden,
                enableSwipeBack: enableSwipeBack
            ),
            animated: animated
        )
    }
    
    /// This method pops the top view controller, if it enabled in CustomHostingViewController
    /// - Parameter animated: Set this value to true to animate the transition or the presentation
    func popView(animated: Bool = true) {
        let viewControllerLast = self.viewControllers.last as? CustomHostingViewControllerProtocol
        if viewControllerLast?.enableSwipeBack ?? true {
            popViewForce(animated: animated)
        }
    }
    
    /// Pops the top view controller forced
    func popViewForce(animated: Bool = true) {
        _ = self.popViewController(animated: animated)
    }
    
    /// Presents View like a sheet
    /// - Parameters:
    ///   - view: The view to display over the current view controller’s content
    ///   - animated: Pass true to animate the presentation
    func presentView(view: some View, animated: Bool = true) {
        self.present(
            UIHostingController(rootView: view),
            animated: animated
        )
    }
    
    /// This method removes the top view controller
    /// - Parameter animated: Set this value to true to animate the transition or the presentation
    func dismiss(animated: Bool = true) {
        self.presentedViewController?.dismiss(animated: animated)
    }
}

extension CustomNavigationController: UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    /// Checks the swipe back availability
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let viewControllerLast = self.viewControllers.last as? CustomHostingViewControllerProtocol
        return viewControllerLast?.enableSwipeBack ?? true
    }
}
