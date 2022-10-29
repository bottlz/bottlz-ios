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
        span: MKCoordinateSpan()
    )

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, interactionModes: [],
                showsUserLocation: true, userTrackingMode: .constant(.follow))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Position: (\(region.center.latitude), \(region.center.longitude))")
                Text("Zoom: \(region.span.latitudeDelta)")
            }
        }
    }
}

struct BottleMap_Previews: PreviewProvider {
    static var previews: some View {
        BottleMap()
    }
}
