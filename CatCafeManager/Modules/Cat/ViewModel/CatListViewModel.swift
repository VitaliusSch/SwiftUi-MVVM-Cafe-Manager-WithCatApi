//
//  CatViewModel.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 30.01.2024.
//

import Foundation
import SwiftUI

/// A Cat view model
final class CatListViewModel: ObservableObject {
    // MARK: published
    @Published var cats: [CatModel] = []
    // MARK: injects
    private let catRepo: RepositoryProtocol
    private let navigation: NavigationControllerProtocol
    private let moneyHolder: MoneyHolderViewModelProtocol
    // MARK: properties
    private var selectedCafe = CafeModel(id: "", title: "", latitude: 0, longitude: 0)
    
    init(
        catRepo: RepositoryProtocol,
        navigation: NavigationControllerProtocol,
        moneyHolder: MoneyHolderViewModelProtocol
    ) {
        self.catRepo = catRepo
        self.navigation = navigation
        self.moneyHolder = moneyHolder
    }
    
    /// Sets the cafe and loads cats from SQLight
    @MainActor func setCafe(cafe: CafeModel) async {
        selectedCafe = cafe
        let catsLoaded: [CatModel] = await self.catRepo.getAsync(stringParam: " cafeId = '\(selectedCafe.id)'")
        self.cats = catsLoaded
    }
    
    ///  Shows cats list to adopt
    @MainActor func adoptCat() async {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        // select a cat
        var selectedCat: CatModel = await navigation.pushViewGenericAsync(
            view: CatAdoptView(),
            animated: true,
            enableSwipeBack: true,
            title: "",
            titleHidden: false, 
            defaultValue: CatModel.aNewCat
        )
        if selectedCat.isEmpty {
            return
        }
        // check exists
        let catsLoaded: [CatModel] = await self.catRepo.getAsync(stringParam: " id = '\(selectedCat.id)'")
        if !catsLoaded.isEmpty {
            await navigation.pushViewAsync(
                view: AlertView(message: "ThisCatAdopted"),
                animated: false,
                titleHidden: true
            )
            return
        }
        // check money
        let catCost = selectedCat.adoptCostWrapped
        if await moneyHolder.addMoney(amount: -catCost, showError: true) {
            selectedCat.cafeId = selectedCafe.id
            if await catRepo.createAsync(entities: [selectedCat]) {
                cats.append(selectedCat)
            }
        }
    }
}
