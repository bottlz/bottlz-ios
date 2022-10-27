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
        center: CLLocationCoordinate2D(latitude: 42.45, longitude: -76.48),
        latitudinalMeters: 750,
        longitudinalMeters: 750
    )

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [.all])
            .edgesIgnoringSafeArea(.all)
    }
}

struct BottleMap_Previews: PreviewProvider {
    static var previews: some View {
        BottleMap()
    }
}
