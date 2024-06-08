//
//  MapViewModel.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 30.11.2022.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

enum MapDefaults {
    static let latitude = 56.8188
    static let longitude = 60.651552
    static let zoom = 1.0
}

public class MapViewModel1: ObservableObject {
//    private let locationManager = AppFactory.container.resolve(LocationManager.self)!
    // Do not use the region as a state object! The map blinks
//    var region: MKCoordinateRegion = MKCoordinateRegion(center:
    // CLLocation(latitude: MapDefaults.latitude, longitude: MapDefaults.longitude).coordinate,
// span: MKCoordinateSpan(latitudeDelta: MapDefaults.zoom, longitudeDelta: MapDefaults.zoom))
//    @Published var errorMessage = ""
//    @Published var selectedRegion: MKCoordinateRegion = DefaultRegion
//
//    func initMap() {
//
//    }
//
//    func setNewRegion(selectedRegion: MKCoordinateRegion) {
//        DispatchQueue.main.async {
//            self.selectedRegion = selectedRegion
//        }
//    }
//
//    func isErrorStatus() -> Bool {
//        return !(locationManager.status == .authorizedAlways || locationManager.status == .authorizedWhenInUse)
//    }
//
//    func showGeolocationSettings() {
////        if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
////            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
////            UIApplication.shared.open(url, options: [:], completionHandler: nil)
////        }
//    }

}
