//
//  ContinuationHandlerClass.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 18.12.2023.
//

/// This class needs to hold and resume a CheckedContinuation
final class ContinuationHolderClass<T> {
    private var continuations: [CheckedContinuation<T, Never>] = []
    
    /// Holds continuation
    /// - Parameter continuation: CheckedContinuation
    func hold(continuation: CheckedContinuation<T, Never>) {
        continuations.append(continuation)
    }
    
    /// Resumes continuation
    /// - Parameter type: Void
    func resumeAndRemove(_ type: T.Type) {
        if !continuations.isEmpty {
            continuations.last?.resume(with: .success(type as! T))
            continuations.removeLast()
        }
    }
}
