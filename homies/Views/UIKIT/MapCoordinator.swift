//
//  MapCoordinator.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/13/23.
//

import Foundation
import MapKit
import SwiftUI

class MapCoordinator : NSObject, MKMapViewDelegate {
    let manager : MapManager

    init(manager : MapManager) {
        self.manager = manager
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        switch annotation {
        case is MKUserLocation:
            return nil
        case is Place:
            let place = annotation as! Place
            let marker = MKAnnotationView(annotation: annotation, reuseIdentifier: "")
            marker.image = UIImage(number: place.price)
            marker.canShowCallout = false
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(annotationTapped))
            marker.addGestureRecognizer(tapGestureRecognizer)
            return marker

//        case is DroppedPin:
//            return nil

        default:
            return nil
        }
    }

//    @MainActor func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        // assume view's annotation is a place
//        let place = view.annotation as! Place
//        manager.showConfirmation = true
//        manager.selectedPlace = place
//    }
    
    @MainActor @objc func annotationTapped(sender: UITapGestureRecognizer) {
        guard let annotationView = sender.view as? MKAnnotationView,
              let annotation = annotationView.annotation as? Place else {
            return
        }
        manager.selectedPlace = annotation
        //show tap here
        manager.destID = annotation.userID
        manager.showPlace = true
    }


}


