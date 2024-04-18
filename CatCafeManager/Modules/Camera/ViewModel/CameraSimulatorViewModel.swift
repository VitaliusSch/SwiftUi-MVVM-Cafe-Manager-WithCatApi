//
//  CameraSimulatorViewModel.swift
//  CatCafeManager
//
//  Created by Mac on 27.02.2024.
//

import Foundation

/// Camera simulator view model
final class CameraSimulatorViewModel: ObservableObject {
    // MARK: published
    @Published var catHolder: Page<CatModel>
    
    // MARK: injects
    private let navigation: CustomNavigationController
    private let imageRepo: any ImageRepositoryProtocol
    private var service: any NetworkingProtocol
    // MARK: properties
    
    init(
        imageRepo: any ImageRepositoryProtocol,
        navigation: CustomNavigationController,
        service: any NetworkingProtocol
    ) {
        self.catHolder = Page<CatModel>(pageSize: 15, currentPage: 0)
        self.imageRepo = imageRepo
        self.navigation = navigation
        self.service = service
    }
    
    /// Fetchs cat from API
    /// - Parameter currentCat: the function will receive the next portion of data if this parameter is not nil
    @MainActor func fetchCats(currentCat: CatModel? = nil) {
        if let currentCat = currentCat {
            if currentCat.id != catHolder.rows.last?.id ?? "" {
                return
            }
        }
        // TODO: make this cancelable to refresh
        if catHolder.isFetching() {
            return
        }
        
        catHolder.setFetching(newValue: true)
        
        Task { [weak self] in
            guard let self = self else { return }
            
            catHolder.increasePage()

            var params: [String: Any] = [:]
            params[AppConstants.Page.PageSize] = "\(catHolder.getPageSize())"
            params[AppConstants.Page.PageNumber] = "\(catHolder.getCurrentPage())"
            // this parameter needs to get ordered array
            params[AppConstants.Page.PageOrder] = "ASC"
            // this parameter needs to access the API and get ordered array
            params[AppConstants.AccessKey.AccessKeyParameterCaption] = AppConstants.AccessKey.AccessKey
            
            let result: Result<[CatModel], Error> = await service.get(parameters: params)
            
            catHolder.setFetching(newValue: false)
            
            switch result {
            case .success(let fetchedCats):
                await MainActor.run {
                    for cat in fetchedCats {
                        if !self.catHolder.rows.contains(where: { $0.id == cat.id}) {
                            self.catHolder.appendRows(newRow: cat)
                        }
                    }
                }
            case .failure(let failure):
                navigation.pushView(view: AlertView(message: "\(failure)"))
            }
        }
    }
}
