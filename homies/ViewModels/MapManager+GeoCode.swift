//
//  MapManager+GeoCode.swift
//  homies
//
//  Created by Phakphum Artkaew on 4/14/23.
//

import Foundation
import MapKit

extension MapManager{
    func searchSetMapRegion(){
        let geoCode = CLGeocoder()
        geoCode.geocodeAddressString(self.address){
            placemark, error in guard error == nil else { return }
            if let placemark = placemark?.first{
                let mapMark = MKPlacemark(placemark: placemark)
                self.region.center = mapMark.coordinate
                self.region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            }
        }
    }
}
