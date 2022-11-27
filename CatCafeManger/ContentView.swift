//
//  ContentView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 25.11.2022.
//

import SwiftUI
import CoreLocationUI
import MapKit

struct ContentView: View {
    
    @StateObject var locationManager = sinjectContainer.resolve(LocationManager.self)!
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: Binding(get: { locationManager.region ?? locationManager.defaultRegion  },
                                          set: { newValue in   }
                                         ),
                showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let location = locationManager.location {
                    Text("**Current location:** \(location.latitude), \(location.longitude)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding()
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                Spacer()
                LocationButton {
                    locationManager.requestLocation()
                }
                .frame(width: 180, height: 40)
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
            }
            .padding()
        }
    }
}
