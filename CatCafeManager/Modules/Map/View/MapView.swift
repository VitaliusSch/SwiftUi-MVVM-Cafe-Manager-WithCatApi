//
//  MapView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 01.12.2022.
//
//

import SwiftUI
import CoreLocationUI

struct MapView: View {
    @StateObject private var locationManager = AppFactory.shared.resolve(LocationManager.self)
    @StateObject private var cafeViewModel = AppFactory.shared.resolve(CafeViewModel.self)

    var body: some View {
        CustomMapView(region: Binding(get: { locationManager.region ?? AppConstants.DefaultRegion },
                                      set: { newValue in
                                                DispatchQueue.main.async {
                                                   locationManager.region = newValue
                                                }
                                           }
                                     ),
                      places: cafeViewModel.cafes.map { $0.mapPlace },
                      onInfoClick: cafeViewModel.onSelectCafeOnMap,
                      onMapClick: cafeViewModel.showNewCafe
        )
        .ignoresSafeArea(.all)
    }
}

// TODO: You can use the SwiftUi Map below, but this content generates error: Publishing changes from within view updates is not allowed, this will cause undefined behavior.
//  it's a bug https://feedbackassistant.apple.com/feedback/1172009 for while

//        Map(coordinateRegion: Binding(get: { self.locationManager.region ?? DefaultRegion },
//                                      set: { newValue in
//                                                DispatchQueue.main.async {
//                                                    self.locationManager.region = newValue
//                                                }
//                                            }
//                                     ),
//            interactionModes: .all,
//            showsUserLocation: false,
//            userTrackingMode: .none,
//            annotationItems: cafeViewModel.mapAnnotation
//        ) { item in
//            MapAnnotation(coordinate: item.coordinate){
//                //this content generates error: Publishing changes from within view updates is not allowed, this will cause undefined behavior.
//                //it's a bug https://feedbackassistant.apple.com/feedback/1172009 for while
//                //try to use MapMarker or MapPin
//        NavigationLink {
//                    Text(item.title)
//                      .font(.callout)
//                      .padding(5)
//                      .background(Color.tertiarySystemBackground)
//                      .cornerRadius(10)
//                      .foregroundColor(.secondaryLabel)
//                    Image(systemName: "arrowtriangle.down.fill")
//                      .foregroundColor(Color.tertiarySystemBackground)
//    }
//                }
//        }
//        .edgesIgnoringSafeArea(.all)
