//
//  Di.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import Foundation
import Swinject
import UIKit

final class AppFactory {
    static var shared = AppFactory()
    private var container = Container()
    
    /// Register the app entities. When the .container is a singletone and .weak is a factory.
    func setUp(customContainer: Container?) {
        if let customContainer = customContainer {
            container = customContainer
            return
        }
        container.register(CustomNavigationController.self, name: NavigationType.main.rawValue) { _ in CustomNavigationController() }
            .inObjectScope(.container)

        container.register(NetworkMonitor.self) { _ in NetworkMonitor() }
            .inObjectScope(.container)
        
        /// The service class factory
        container.register(Service.self) { _, route in Service(route: route, requestDispatcher: RequestDispatcher()) }
            .inObjectScope(.weak)
        
        registerRepositories()
        
        container.register(LocationManager.self) { _ in LocationManager() }
            .inObjectScope(.container)
        
        registerViewModel()
        
        // Init SQLight
        try? SQLiteRepository.shared.setUp()
    }
    
    func registerRepositories() {
        container.register(ImageRepository.self) { _ in
            ImageRepository()
        }
        .inObjectScope(.container)
        
        /// We call local tables like cafeModel  because this is the GRDB generic rules
        container.register(CafeRepository.self) { _ in CafeRepository(tableName: "cafeModel", database: SQLiteRepository.shared) }
            .inObjectScope(.weak)

        /// Needs to init and migrate SQLite
        SQLiteRepository.shared.addRepoToMigration(repo: resolve(CafeRepository.self))

        container.register(CatRepository.self) { _ in CatRepository(tableName: "catModel", database: SQLiteRepository.shared) }
            .inObjectScope(.weak)

        SQLiteRepository.shared.addRepoToMigration(repo: resolve(CatRepository.self))
    }
    
    func registerViewModel() {
        container.register(CameraViewModel.self) { _ in CameraViewModel() }
            .inObjectScope(.weak)
        
        container.register(MoneyHolderViewModel.self) { resolver in
            MoneyHolderViewModel(
                navigation: resolver.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)!, 
                catRepo: resolver.resolve(CatRepository.self)!
            )
        }
        .inObjectScope(.container)
        
        /// Only one MainViewModel stored in container
        container.register(MainViewModel.self) { _ in MainViewModel() }
            .inObjectScope(.container)
        
        /// Only one CafeViewModel
        container.register(CafeViewModel.self) { resolver in
            CafeViewModel(
                cafeRepo: resolver.resolve(CafeRepository.self)!,
                navigation: resolver.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)!,
                imageRepo: resolver.resolve(ImageRepository.self)!
            )
        }
        .inObjectScope(.container)
        /// Cat's view model
        container.register(CatListViewModel.self) { resolver in
            CatListViewModel(
                catRepo: resolver.resolve(CatRepository.self)!,
                navigation: resolver.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)!,
                moneyHolder: resolver.resolve(MoneyHolderViewModel.self)!
            )
        }
        .inObjectScope(.weak)
        container.register(CatAdoptViewModel.self) { resolver in
            CatAdoptViewModel(
                navigation: resolver.resolve(CustomNavigationController.self, name: NavigationType.main.rawValue)!,
                service: resolver.resolve(Service.self, argument: AppRoutes.Cats)!
            )
        }
        .inObjectScope(.weak)
    }
    /// Retrieves the instance with the specified service type and registration name.
    /// - Parameters:
    ///   - type: The service type to resolve.
    ///   - name: The registration optional name.
    /// - Returns: The resolved service type instance
    func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        container.resolve(T.self, name: name)!
    }
    /// Retrieves the instance with the specified service type and registration name and one argument.
    /// - Parameters:
    ///   - type: The service type to resolve.
    ///   - name: The registration optional name.
    ///   - argument: One argument to pass to the factory closure.
    /// - Returns: The resolved service type instance
    func resolve<T>(_ type: T.Type, argument: String, name: String? = nil) -> T {
        container.resolve(T.self, name: name, argument: argument)!
    }
}
