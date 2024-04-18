//
//  MoneyKeeperViewModel.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 06.02.2024.
//

import Foundation

protocol MoneyHolderViewModelProtocol {
    var money: Int { get }
    func addMoney(amount: Int, showError: Bool) async -> Bool
    func calculateByAlgorithm(cats: [CatModel]) -> Int
}

/// Holds all your money
final class MoneyHolderViewModel: ObservableObject, MoneyHolderViewModelProtocol {
    // MARK: published
    @Published var money: Int
    // MARK: injects
    private let navigation: NavigationControllerProtocol
    // MARK: properties
    private var storedMoney: Int {
        get { return UserDefaults.standard.integer(forKey: AppConstants.Money.UserDefaultsName) }
        set { UserDefaults.standard.set(newValue, forKey: AppConstants.Money.UserDefaultsName) }
    }
    private var timer: Timer?
    private var catRepo: RepositoryProtocol
    init(
        navigation: NavigationControllerProtocol,
        catRepo: RepositoryProtocol
    ) {
        self.navigation = navigation
        self.catRepo = catRepo
        
        if let savedMoney = UserDefaults.standard.value(forKey: AppConstants.Money.UserDefaultsName) {
            self.money = (savedMoney as? Int) ?? AppConstants.Money.StartAmount
        } else {
            self.money = AppConstants.Money.StartAmount
            UserDefaults.standard.set(self.money, forKey: AppConstants.Money.UserDefaultsName)
        }
        // TODO: add calculation based on time in offline
        timer = Timer.scheduledTimer(withTimeInterval: AppConstants.Money.ScheduletTime, repeats: true) { [weak self] _ in
            self?.calculate()
        }
    }
    
    @discardableResult 
    @MainActor public func addMoney(amount: Int, showError: Bool) async -> Bool {
        if storedMoney + amount < 0 {
            if showError {
                await navigation.pushViewAsync(view: AlertView(message: "NotEnoughtMoney"), animated: false, titleHidden: true)
            }
            return false
        }
        storedMoney += amount
        money = storedMoney
        return true
    }
    
    /// Calculates your money based on the number of cats you have
    private func calculate() {
        Task { [weak self] in
            let allCats: [CatModel] = await self?.catRepo.getAsync() ?? []
            let calculated = self?.calculateByAlgorithm(cats: allCats) ?? 0
            await self?.addMoney(amount: calculated, showError: false)
        }
    }
    
    // simple calculation algorithm
    func calculateByAlgorithm(cats: [CatModel]) -> Int {
        return cats.count
    }
}
