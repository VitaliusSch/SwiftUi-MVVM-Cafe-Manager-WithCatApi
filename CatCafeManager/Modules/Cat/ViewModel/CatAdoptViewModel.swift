//
//  CatListViewModel.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 02.02.2024.
//

import Foundation
import SwiftUI

/// A Cat list view model
final actor CatAdoptViewModel: ObservableObject {
    // MARK: published
    @Published @MainActor var catList: [CatModel] = []
    @Published @MainActor var isFetching = false

    // MARK: injects
    private let navigation: NavigationControllerProtocol
    private var service: NetworkingProtocol
    // MARK: properties
    private var catPageHolder: Page<CatModel> = Page<CatModel>(pageSize: 15, currentPage: 0)
    
    init(
        navigation: NavigationControllerProtocol,
        service: NetworkingProtocol
    ) {
        self.navigation = navigation
        self.service = service
    }
    
    /// Fetchs cats from API
    /// - Parameter currentCat: the function will receive the next portion of data if this parameter is not nil
    func fetchCats(currentCat: CatModel? = nil) async {
        // TODO: make this cancelable to refresh
        if await isFetching {
            return
        }
        if let currentCat = currentCat {
            if await currentCat.id != catList.last?.id ?? "" {
                return
            }
        }

        await MainActor.run {
            isFetching = true
        }
        
        catPageHolder.increasePage()
        
        let result: Result<[CatModel], Error> = await service.get(parameters: catPageHolder.makeParams())
        
        await MainActor.run {
            isFetching = false
        }
        switch result {
        case .success(let fetchedCats):
            await MainActor.run {
                for cat in fetchedCats {
                    // if you d'not have an Access Key, then you need to check the entry, because the API returns unsorted data
                    if !catList.contains(where: { $0.id == cat.id}) {
                        catList.append(
                            CatModel(
                                id: cat.id,
                                url: cat.url,
                                width: cat.width,
                                height: cat.height,
                                name: CatModel.randomName,
                                adoptCost: CatModel.randomCost
                            )
                        )
                    }
                }
            }
        case .failure(let failure):
            navigation.pushView(
                view: AlertView(message: "\(failure)"),
                animated: true,
                enableSwipeBack: true,
                title: "",
                titleHidden: false
            )
        }
    }
}
