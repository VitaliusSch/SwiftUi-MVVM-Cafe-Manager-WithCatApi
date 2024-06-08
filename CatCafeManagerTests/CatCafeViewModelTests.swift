//
//  CatCafeViewModelsTests.swift
//  CatCafeManagerTests
//
//  Created by VitaliusSch on 01.04.2024.
//

import XCTest
@testable import CatCafeManager
import Swinject
import GRDB

final class CatCafeViewModelTests: XCTestCase {
    private let container = Container()
    private let sqLite = SQLiteRepository()
    private let navigation = MockNavigationController()
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        
        container.register(ImageRepository.self) { _ in
            ImageRepository()
        }
        .inObjectScope(.container)
        
        container.register(Service.self) { _, route in Service(route: route, requestDispatcher: MockCatsApi()) }
            .inObjectScope(.weak)
        
        container.register(MockCafeRepository.self) { _ in MockCafeRepository(tableName: "cafeModel", database: self.sqLite) }
            .inObjectScope(.weak)

        container.register(MockCatRepositopy.self) { _ in MockCatRepositopy(tableName: "catModel", database: self.sqLite) }
            .inObjectScope(.weak)

        UserDefaults.standard.removeObject(forKey: AppConstants.Money.UserDefaultsName)
        
        container.register(MoneyHolderViewModel.self) { resolver in
            MoneyHolderViewModel(
                navigation: self.navigation,
                catRepo: resolver.resolve(MockCatRepositopy.self)!
            )
        }
        .inObjectScope(.container)
        
        container.register(CafeViewModel.self) { resolver in
            CafeViewModel(
                cafeRepo: resolver.resolve(MockCafeRepository.self)!,
                navigation: self.navigation,
                imageRepo: resolver.resolve(ImageRepository.self)!
            )
        }
        .inObjectScope(.container)
        
        container.register(CatListViewModel.self) { resolver in
            CatListViewModel(
                catRepo: resolver.resolve(MockCatRepositopy.self)!,
                navigation: self.navigation,
                moneyHolder: resolver.resolve(MoneyHolderViewModel.self)!
            )
        }
        .inObjectScope(.weak)
        
        container.register(CatAdoptViewModel.self) { resolver in
            CatAdoptViewModel(
                navigation: self.navigation,
                service: resolver.resolve(Service.self, argument: AppRoutes.Cats)!
            )
        }
        .inObjectScope(.weak)


        //try? sqLite.setUp()
    }

    func testMoneyHolderViewModel() async {
        XCTAssertTrue(container.resolve(MoneyHolderViewModel.self) != nil, "MoneyHolderViewModel must be resolved")

        let moneyHolderViewModel = container.resolve(MoneyHolderViewModel.self)!
        XCTAssertEqual(moneyHolderViewModel.money, 100, "The amount of money must be 100")
        
        await moneyHolderViewModel.addMoney(amount: -44, showError: true)
        XCTAssertEqual(moneyHolderViewModel.money, 56, "The amount of money must be 66 after purchase")
        
        let purchaseIsComplete = await moneyHolderViewModel.addMoney(amount: -80, showError: true)
        XCTAssertFalse(purchaseIsComplete, "Enough money")
    }

    func testCatListViewModel() async {
        let moneyHolderViewModel = container.resolve(MoneyHolderViewModel.self)!
        await moneyHolderViewModel.addMoney(amount: 44, showError: true)
        
        XCTAssertTrue(container.resolve(CatListViewModel.self) != nil, "CatListViewModel must be resolved")

        let catListViewModel = container.resolve(CatListViewModel.self)!
        await catListViewModel.setCafe(cafe: CafeModel(id: "1", title: "A Cafe", latitude: 0, longitude: 0))
        XCTAssertEqual(catListViewModel.cats.count, 2, "Cats in the cafe must be 2")

        await catListViewModel.adoptCat()
        XCTAssertEqual(catListViewModel.cats.count, 3, "Once a cat is adopted, there should be 3 cats in the cafe")
    }

    func testCatAdoptViewModel() async {
        XCTAssertTrue(container.resolve(CatAdoptViewModel.self) != nil, "CatAdoptViewModel must be resolved")

        let catAdoptViewModel = container.resolve(CatAdoptViewModel.self)!

        await MainActor.run {
            XCTAssertEqual(catAdoptViewModel.catList.count, 0, "Cats in the cafe must be 0")
        }
        
        await catAdoptViewModel.fetchCats()
        
        await MainActor.run {
            XCTAssertEqual(catAdoptViewModel.catList.count, 1, "Cats in the cafe must be 1")
        }
    }

    func testCafeViewModel() async {
        XCTAssertTrue(container.resolve(CafeViewModel.self) != nil, "CafeViewModel must be resolved")

        let cafeViewModel = container.resolve(CafeViewModel.self)!

        XCTAssertEqual(cafeViewModel.cafes.count, 0, "Number of cafes must be 0")
        
        await cafeViewModel.loadFromLocal()
        
        XCTAssertEqual(cafeViewModel.cafes.count, 1, "Number of cafes must be 1")
        
        await cafeViewModel.showCafeCardView(cafeToSelect: CafeModel(id: "11", title: "Soft Paws", latitude: 0, longitude: 0))
        
        XCTAssertEqual(cafeViewModel.selectedCafe.title, "Soft Paws", "The title of the selected cafe should be Soft Paws")
        
        await cafeViewModel.save()
        
        XCTAssertEqual(cafeViewModel.cafes.count, 2, "Number of cafes must be 2")
    }
}
