//
//  UIMAP.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/13/23.
//

import SwiftUI
import MapKit

struct UIMap: UIViewRepresentable {
    @ObservedObject var manager : MapManager

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.setRegion(manager.region, animated: true)
        mapView.delegate = context.coordinator

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        for i in manager.nearbyRentalUnits{
            if(manager.showornoshow(rentalUnit: i)){
                mapView.addAnnotation(i)
            }
        }
//        mapView.addAnnotations(manager.nearbyRentalUnits)
    }

    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(manager: manager)
    }
}
