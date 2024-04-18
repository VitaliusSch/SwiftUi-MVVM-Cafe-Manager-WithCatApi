//
//  MapAnnotaion.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 06.12.2022.
//

import MapKit
import SwiftUI

final class MapPlaceModel: NSObject, Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let location: CLLocation
    let cafeId: String
    
    init(name: String, image: String, location: CLLocation, cafeId: String) {
        self.name = name
        self.image = image
        self.location = location
        self.cafeId = cafeId
    }
}

extension MapPlaceModel: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        location.coordinate
    }
    
    var title: String? {
        name
    }
}
