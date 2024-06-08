//
//  ReturnValueViewModel.swift
//  CatCafeManager
//
//  Created by Mac on 29.05.2024.
//

import Foundation

final class ReturnValueViewModel<T>: ObservableObject {
    private var streamContinuation: AsyncStream<T>.Continuation
    private let navigation: NavigationControllerProtocol

    init(
        streamContinuation: AsyncStream<T>.Continuation,
        navigation: NavigationControllerProtocol
    ) {
        self.streamContinuation = streamContinuation
        self.navigation = navigation
    }
    
    func checkAndContinue(value: T) {
        streamContinuation.yield(value)
        streamContinuation.finish()
        navigation.popViewAsync()
    }
}
