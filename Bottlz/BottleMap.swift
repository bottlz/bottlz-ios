//
//  BottleMap.swift
//  Bottlz
//
//  Created by Changyuan Lin on 10/26/22.
//

import SwiftUI
import MapKit

struct BottleMap: View {
    var bottles: [Bottle]

    @State private var region = MKCoordinateRegion(
        center: LocationManager.currentLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )

    var body: some View {
        ZStack() {
            Map(coordinateRegion: $region, interactionModes: [.all],
                showsUserLocation: true, userTrackingMode: .constant(.follow),
                annotationItems: bottles)
            { bottle in
                MapAnnotation(coordinate: bottle.origin) {
                    Button {
                        print("Bottle ID", bottle.id)
                    } label: {
                        Image("Bottle")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                            .background(in: Circle())
                            .frame(width: 30.0, height: 30.0)
                            .shadow(radius: 4)
                    }
                }
            }
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
        BottleMap(bottles: [
            Bottle(lat: 42.451, lon: -76.481),
            Bottle(lat: 42.451, lon: -76.479),
            Bottle(lat: 42.449, lon: -76.481),
            Bottle(lat: 42.449, lon: -76.479)
        ])
    }
}
