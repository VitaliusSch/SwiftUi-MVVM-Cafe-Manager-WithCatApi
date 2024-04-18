//
//  CustomMapView.swift
//  CatCafeManger
//
//  Created by VitaliusSch on 06.12.2022.
//
//  You can use Map and MapAnnotaion, but this generates a purple warning error in Xcode 14.1 at the moment
//  This also blocks the maximum zooming
//  it's a bug https://feedbackassistant.apple.com/feedback/1172009 for while

import Foundation
import MapKit
import SwiftUI

/// MapView implementation
struct CustomMapView: UIViewRepresentable {
    var region: Binding<MKCoordinateRegion>
    var places: [MapPlaceModel]
    let onInfoClick: (MapPlaceModel) -> Void
    let onMapClick: (CLLocationCoordinate2D) -> Void
    fileprivate let customMapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        customMapView.setRegion(region.wrappedValue, animated: true)
        customMapView.isRotateEnabled = false
        customMapView.delegate = context.coordinator
        customMapView.addAnnotations(places)
        let recognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.onTapGesture(sender:)))
        customMapView.addGestureRecognizer(recognizer)
        return customMapView
    }
    
    /// When MapView updated then we check current region
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // TODO: make a Bool var to full refresh
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(places)
        if region.wrappedValue.center.longitude == AppConstants.DefaultRegion.center.longitude &&
            region.wrappedValue.center.latitude == AppConstants.DefaultRegion.center.latitude {
            return
        }
        
        if uiView.region.center.longitude != region.wrappedValue.center.longitude ||
            uiView.region.center.latitude != region.wrappedValue.center.latitude {
            uiView.region = region.wrappedValue
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(self)
    }
}

/// MapView delegates
final class MapCoordinator: NSObject, MKMapViewDelegate {
    var parent: CustomMapView
    
    init(_ parent: CustomMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView =
            mapView.dequeueReusableAnnotationView(withIdentifier: "mapAnnotation") as? MKMarkerAnnotationView ??
            MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "mapAnnotation")

        annotationView.canShowCallout = true // set the canShowCallout to false to represent the annotation as a bubble
        annotationView.glyphText = "♨"
        // annotationView.glyphImage = UIImage(systemName: "cart") // the marker custom UIImage
        // annotationView.markerTintColor = .systemWhite // the marker color
        annotationView.markerTintColor = .white
        annotationView.titleVisibility = .visible
        let button = UIButton(type: .detailDisclosure)
        let image = UIImage(systemName: "")
        button.setImage(image, for: .normal)
        annotationView.rightCalloutAccessoryView = button
        return annotationView
    }
    
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        if parent.region.wrappedValue.center.longitude == defaultRegion.center.longitude &&
//            parent.region.wrappedValue.center.latitude == defaultRegion.center.latitude {
//            return
//        }
//        parent.region.wrappedValue = mapView.region
//    }
    
    /// Tap on the info
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let place = view.annotation as? MapPlaceModel else { return }
        parent.onInfoClick(place)
    }
    
    /// Tap on the view annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // parent.onAnnotationClick(view.annotation)
    }
    
    /// Tap Gesture Recognizer
    @objc func onTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let touch = sender.location(in: parent.customMapView)
            let coord = parent.customMapView.convert(touch, toCoordinateFrom: parent.customMapView)
            
            /// If the user clicks on the annotation, we will skip creating a new cafe
            if getTappedAnnotations(sender: sender).isEmpty {
                parent.onMapClick(coord)
            }
        }
    }
    
    /// Calculating tapped annotations
    private func getTappedAnnotations(sender: UITapGestureRecognizer) -> [MKAnnotationView] {
        var tappedAnnotations: [MKAnnotationView] = []
        for annotation in parent.customMapView.annotations {
            if let annotationView: MKAnnotationView = parent.customMapView.view(for: annotation) {
                let annotationPoint = sender.location(in: annotationView)
                if CGRectContainsPoint(annotationView.bounds, annotationPoint) {
                    tappedAnnotations.append(annotationView)
                }
            }
        }
        return tappedAnnotations
    }
}
