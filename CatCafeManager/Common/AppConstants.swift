//
//  AppConstants.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 11.01.2023.
//

import CoreLocation
import MapKit

enum AppConstants {
    enum AccessKey {
        public static let AccessKey = ""
        public static let AccessKeyParameterCaption = "api_key"
    }
    
    enum Date {
        public static let FormatLocalDate = "dd.MM.yyyy"
        public static let FormatLocalAmericanDate = "yyyy-MM-dd"
        public static let FormatLogDate = "yyyy-MM-dd-HH"
        public static let FormatLocalDateTime = "dd.MM.yyyy HH:mm"
    }
    public static let DefaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.477928, longitude: -0.001545),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    enum Page {
        public static let PageSize = "limit"
        public static let PageNumber = "page"
        public static let PageOrder = "order"
    }
    
    enum Money {
        public static let UserDefaultsName = "money"
        public static let StartAmount = 100
        public static let ScheduletTime = 60.0
    }
    
    enum Cat {
        public static let Names = [
                "Phoebe",
                "Endmund",
                "Dinky",
                "Nugget",
                "Flubber",
                "Cleo",
                "Loki",
                "Bella",
                "Lacy",
                "Caesar",
                "Felicity",
                "Mila",
                "Scrubbie",
                "CoCo",
                "Nichole",
                "Felix",
                "Flubber",
                "Cheerio",
                "Neko",
                "Shadow",
                "Gino",
                "Hammy",
                "Rahul",
                "Tickles",
                "Charly",
                "Roxy",
                "Felix",
                "Zizzi",
                "Tink",
                "Pax",
        ]
    }
}

enum NavigationType: String, EnumExtension {
    case main
    case second
}
