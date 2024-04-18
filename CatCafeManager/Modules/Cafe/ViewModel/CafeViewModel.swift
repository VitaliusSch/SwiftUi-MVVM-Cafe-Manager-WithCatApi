//
//  CafeViewModel.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 01.12.2022.
//

import Foundation
import SwiftUI
import MapKit
import Combine

/// A cafe view model
final class CafeViewModel: ObservableObject {
    // MARK: published
    @Published var cafes: [CafeModel] = []
    @Published var selectedCafe: CafeModel
    @Published var image: UIImage?
    @Published var searchText: String = ""
    @Published var aNewCafe = false
    var needRefreshPhoto = PassthroughSubject<Bool, Never>()
    
    // MARK: injects
    private let cafeRepo: RepositoryProtocol
    private let navigation: NavigationControllerProtocol
    private let imageRepo: ImageRepositoryProtocol
    // MARK: properties
    private var subscriptions = Set<AnyCancellable>()
    
    init(
        cafeRepo: RepositoryProtocol,
        navigation: NavigationControllerProtocol,
        imageRepo: ImageRepositoryProtocol
    ) {
        self.cafeRepo = cafeRepo
        self.navigation = navigation
        self.selectedCafe = CafeModel(id: "", title: "", latitude: 0, longitude: 0)
        self.imageRepo = imageRepo
        
        $searchText
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .sink(
                receiveValue: {
                    debouncedText in
                    Task { [weak self] in
                        await self?.loadFromLocal(debouncedText: debouncedText)
                    }
                }
            )
            .store(in: &subscriptions)
    }
    
    deinit {
        subscriptions.removeAll()
    }
    
    // Loading saved data
    @MainActor func loadFromLocal(debouncedText: String = "") async {
        if debouncedText.isEmpty {
            self.cafes = await self.cafeRepo.getAsync(stringParam: "")
        } else {
            self.cafes = await self.cafeRepo.getAsync(stringParam: " title LIKE '%\(debouncedText)%'")
        }
    }
    
    // Shows new cafe view by touch on the map
    @MainActor func showNewCafe(location: CLLocationCoordinate2D) {
        let newCafe = CafeModel(
            id: UUID().uuidString.lowercased(),
            title: "",
            latitude: location.latitude,
            longitude: location.longitude
        )
        self.showCafeCardView(cafeToSelect: newCafe, newCafe: true)
    }
    
    /// Shows a cafe view by click on an annotation
    @MainActor func onSelectCafeOnMap(map: MapPlaceModel) {
        if let idx = self.cafes.firstIndex(where: { $0.id == map.cafeId }) {
            self.showCafeCardView(cafeToSelect: self.cafes[idx])
        }
    }
    
    /// Shows camera to get a cafe avatar
    func showCameraToAvatar() {
#if !targetEnvironment(simulator)
        self.navigation.presentView(
            view: CameraView(
                givePhoto: { image in
                    Task { [weak self] in
                        await self?.setCafeIcon(image: image)
                    }
                }
            ),
            animated: true
        )
#endif
    }
    
    /// Sets an image as the icon of cafe
    /// - Parameter image: image to set
    @MainActor func setCafeIcon(image: UIImage?) async {
        navigation.dismiss(animated: true)
        self.imageRepo.saveImage(image: image, url: self.selectedCafe.imageURL)
        aNewCafe = true
        await self.save()
        self.needRefreshPhoto.send(true)
    }
    
    /// Saves the selected cafe changes
    @discardableResult
    @MainActor func save() async -> Bool {
        if selectedCafe.title.isEmpty {
            navigation.pushView(
                view: AlertView(message: "CafeWrongName"),
                animated: false,
                enableSwipeBack: true,
                title: "",
                titleHidden: true)
            return false
        }
        cafes = cafes.filter {$0.id != selectedCafe.id}
        cafes.append(selectedCafe)
        _ = await cafeRepo.createAsync(entities: [selectedCafe])
        if !aNewCafe {
            navigation.popView(animated: true)
        }
        aNewCafe = false
        return true
    }
    
    /// Selects and Shows a cafe
    /// - Parameter cafeToSelect: a cafe to select
    @MainActor func showCafeCardView(cafeToSelect: CafeModel? = nil, newCafe: Bool = false) {
        aNewCafe = newCafe
        if let cafeToSelect = cafeToSelect {
            selectedCafe = cafeToSelect
        }
        navigation.pushView(
            view: CafeCardView(),
            animated: true,
            enableSwipeBack: true,
            title: "",
            titleHidden: false
        )
    }
}
