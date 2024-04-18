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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if checkContinuation != nil {
            checkContinuation?.resume(with: .success(Void()))
        }
    }
}
