//
//  MockNavigationController.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 08.04.2024.
//

import Foundation
@testable import CatCafeManager
import SwiftUI

final class MockNavigationController: NavigationControllerProtocol {
    func pushViewGenericAsync<T>(view: some View, animated: Bool, enableSwipeBack: Bool, title: String, titleHidden: Bool, defaultValue: T) async -> T {
        if view is CatAdoptView {
            return CatModel(id: "3", url: "https://cdn2.thecatapi.com/images/3.jpg", width: 0, height: 0, name: "mew cat", cafeId: "1", adoptCost: 12) as! T
        }
        return CatModel.aNewCat as! T
    }
    
    func popViewAsync(animated: Bool) {
        
    }
    
    func pushViewAsync(view: some View, animated: Bool, enableSwipeBack: Bool, title: String, titleHidden: Bool) async {
        // TODO: test with callback
//        if let adoptView = view as? CatAdoptView {
//            await adoptView.onCatSelect(
//                CatModel(id: "3", url: "https://cdn2.thecatapi.com/images/3.jpg", width: 0, height: 0, name: "mew cat", cafeId: "1", adoptCost: 12)
//            )
//        }
    }
    
    func pushView(view: some View, animated: Bool, enableSwipeBack: Bool, title: String, titleHidden: Bool) {
        
    }
    
    func popView(animated: Bool) {
        
    }
    
    func popViewForce(animated: Bool) {
        
    }
    
    func presentView(view: some View, animated: Bool) {
        
    }
    
    func dismiss(animated: Bool) {
        
    }

}
