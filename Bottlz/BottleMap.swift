//
//  BottleMap.swift
//  Bottlz
//
//  Created by Changyuan Lin on 10/26/22.
//

import SwiftUI
import MapKit

struct BottleMap: View {

    @State private var region = MKCoordinateRegion(
        center: LocationManager.currentLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )

    var body: some View {
        ZStack() {
            Map(coordinateRegion: $region, interactionModes: [.all],
                showsUserLocation: true, userTrackingMode: .constant(.follow))
            VStack {
                Text("Region Position: (\(region.center.latitude), \(region.center.longitude))")
                Text("Region Zoom: \(region.span.latitudeDelta)")
                Text("LocationManager Position: (\(LocationManager.currentLocation.latitude), \(LocationManager.currentLocation.longitude))")
            }
        }
    }
}

struct BottleMap_Previews: PreviewProvider {
    static var previews: some View {
        BottleMap()
    }
}
