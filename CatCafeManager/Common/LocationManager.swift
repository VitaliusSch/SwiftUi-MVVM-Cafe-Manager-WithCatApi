//
//  LocationManager.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import Foundation
import CoreLocation
import MapKit

protocol LocationManagerProtocol: NSObject, ObservableObject, CLLocationManagerDelegate {
    var region: MKCoordinateRegion? { get set }
}

/// Location Manager
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, LocationManagerProtocol {
    // MARK: published region
    @Published var region: MKCoordinateRegion?
    // MARK: private
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var location: CLLocation?
    private var status = CLAuthorizationStatus.notDetermined
    // MARK: onChangeStatus
    var onChangeStatus: (() -> Void)?
    // MARK: init
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        // MARK: Use the startUpdatingLocation carefull ... high power impact!
        locationManager.startUpdatingLocation()
    }
    /// request Location
    func requestLocation() {
        locationManager.requestLocation()
    }
    // MARK: did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        if self.location != nil {
            return
        }
        Task { @MainActor [weak self] in
            self?.location = location
            self?.region = MKCoordinateRegion(
                center: location.coordinate,
                span: AppConstants.DefaultRegion.span
            )
        }
    }
    // MARK: did Change Authorization
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if self.status != status {
            self.status = status

            if let onChangeStatus = self.onChangeStatus {
                onChangeStatus()
            }
            locationManager.stopUpdatingLocation()
        }
    }
    // MARK: did Fail With Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// TODO: async get location
// class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?
//    let manager = CLLocationManager()
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocation() async throws -> CLLocationCoordinate2D? {
//        try await withCheckedThrowingContinuation { continuation in
//            locationContinuation = continuation
//            manager.requestLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locationContinuation?.resume(returning: locations.first?.coordinate)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationContinuation?.resume(throwing: error)
//    }
// }
