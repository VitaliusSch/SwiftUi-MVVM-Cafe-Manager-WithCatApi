//
//  CafeModel.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 29.11.2022.
//

import GRDB
import MapKit

/// A cafe model
struct CafeModel: BasicModel, ImageProtocol {
    var id: String
    var title: String
    var latitude: Double
    var longitude: Double
}

extension CafeModel {
    var coordinate: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(
                latitude: self.latitude,
                longitude: self.longitude
            )
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }

    var mapPlace: MapPlaceModel {
        MapPlaceModel(
            name: self.title,
            image: "",
            location: CLLocation(
                latitude: self.latitude,
                longitude: self.longitude
            ),
            cafeId: self.id
        )
    }
    
    var imageURL: URL? {
        FileManager.default.documentDirectoryFile(fileId: id)
    }
}
