//
//  MapKitSearcher.swift
//  CatCafeManager
//
//  Created by VitaliusSch on 26.06.2023.
//

import Foundation
import MapKit

/// MKLocalSearch implementation
final class MapKitSearcher {
    private let locationManager: any LocationManagerProtocol = AppFactory.shared.resolve(LocationManager.self)
    // Sydney
    private enum MapDefaults {
        static let latitude = -33.865143
        static let longitude = 151.209900
        static let zoom = 10.1
    }
    private let defaultLocation = CLLocation(
        latitude: MapDefaults.latitude,
        longitude: MapDefaults.longitude
    )
    private var region = MKCoordinateRegion(
        center: CLLocation(latitude: MapDefaults.latitude,
                           longitude: MapDefaults.longitude
                          ).coordinate,
        latitudinalMeters: CLLocationDistance(10),
        longitudinalMeters: CLLocationDistance(10)
    )
    /// Starts search
    /// - Parameter searchString: search string
    func search(searchString: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = locationManager.region ?? region
        let search = MKLocalSearch(request: request)
        search.start( completionHandler: { [weak self] response, error in
                guard let response = response else {
                    return
                }
                if error != nil {
                    print("Error occured in search \(String(describing: error))")
                    return
                }
                if response.mapItems.isEmpty {
                    print("No matches found")
                    return
                }
                print("Matches found")
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.coordinate = item.placemark.coordinate
                    // TODO: make a callback to setUp annotations
//                    DispatchQueue.main.async {
//                        self.MapView.addAnnotation(annotation)
//                    }
                    print("Name = \(String(describing: item.name))")
                    print("Phone = \(String(describing: item.phoneNumber))")
                    print("Website = \(String(describing: item.url))")
                }
                self?.locationManager.region = MKCoordinateRegion(
                    center: response.mapItems[1].placemark.coordinate,
                    latitudinalMeters: CLLocationDistance(1_000),
                    longitudinalMeters: CLLocationDistance(1_000)
                )
        }
        )
    }
}
