//
//  UINavigationController.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 25.09.2023.
//

import UIKit
import SwiftUI

protocol CustomHostingViewControllerProtocol {
    var enableSwipeBack: Bool { get set }
    var checkContinuation: CheckedContinuation<Void, Never>? { get set }
}

protocol GenericHostingViewControllerProtocol {
    associatedtype Out
    var enableSwipeBack: Bool { get set }
    var streamContinuation: AsyncStream<Out>.Continuation { get set }
}

/// A custom UIHostingController to hold custom navigation properties
class CustomHostingController<Content>: UIHostingController<AnyView>, CustomHostingViewControllerProtocol where Content: View {
    internal var enableSwipeBack: Bool
    internal var checkContinuation: CheckedContinuation<Void, Never>?
    
    public init(
        rootView: Content,
        navigationBarTitle: String,
        navigationBarHidden: Bool = false,
        enableSwipeBack: Bool = true,
        checkContinuation: CheckedContinuation<Void, Never>? = nil
    ) {
        self.enableSwipeBack = enableSwipeBack
        self.checkContinuation = checkContinuation

        super.init(
            rootView: AnyView(
                rootView.navigationBarHidden(navigationBarHidden)
            )
        )
        
        self.title = navigationBarTitle
    }

    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    deinit {
        if checkContinuation != nil {
            checkContinuation?.resume(with: .success(Void()))
        }
    }
}

/// A generic UIHostingController to hold custom navigation properties
class GenericHostingController<Content, T>: UIHostingController<AnyView>, GenericHostingViewControllerProtocol where Content: View {
    internal var enableSwipeBack: Bool
    internal var streamContinuation: AsyncStream<T>.Continuation

    public init(
        view: Content,
        navigationBarTitle: String,
        navigationBarHidden: Bool = false,
        enableSwipeBack: Bool = true,
        streamContinuation: AsyncStream<T>.Continuation,
        navigation: NavigationControllerProtocol
    ) {
        self.enableSwipeBack = enableSwipeBack
        self.streamContinuation = streamContinuation

        super.init(
            rootView: AnyView(
                view
                    .navigationBarHidden(navigationBarHidden)
                    .environmentObject(
                        ReturnValueViewModel(
                            streamContinuation: streamContinuation,
                            navigation: navigation
                        )
                    )
            )
        )
        
        self.title = navigationBarTitle
    }

    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    deinit {
        streamContinuation.finish()
    }
}
