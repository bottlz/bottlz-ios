//
//  BottleMap.swift
//  Bottlz
//
//  Created by Changyuan Lin on 10/26/22.
//

import SwiftUI
import MapKit

struct BottleMap: View {
    @EnvironmentObject var bottleFetcher: BottleFetcher
    @Binding var showViewBottle: Bool

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.45, longitude: -76.48),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )

    @State private var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack() {
            Map(coordinateRegion: $region, interactionModes: [.all],
                showsUserLocation: true, userTrackingMode: .constant(.follow),
                annotationItems:
//                    bottleFetcher.bottleData.flatMap { bottle in bottle.routeAnnotations })
                    bottleFetcher.bottleData)
            { bottle in
                MapAnnotation(coordinate: bottle.computeCurrentLocation(currentDate: currentDate)) {
                    Button {
                        print("Bottle ID", bottle.id)
                        bottleFetcher.selectedBottle = bottle
                        showViewBottle = true
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
//                MapAnnotation(coordinate: bottle.point) {
//                    Circle()
//                        .foregroundColor(Color(white: bottle.portion))
//                        .frame(width: 3, height: 3)
//                }
            }
            VStack {
                Text("Region Position: (\(region.center.latitude), \(region.center.longitude))")
                Text("Region Zoom: \(region.span.latitudeDelta)")
            }
        }
        .onReceive(timer) { input in
            print("Current time: \(input)")
            currentDate = input
        }
    }
}

struct BottleMap_Previews: PreviewProvider {
    static var previews: some View {
        BottleMap(showViewBottle: .constant(false))
            .environmentObject(BottleFetcher(
                bottleData: [
                    Bottle(lat: 42.451, lon: -76.481),
                    Bottle(lat: 42.451, lon: -76.479),
                    Bottle(lat: 42.449, lon: -76.481),
                    Bottle(lat: 42.449, lon: -76.479)
                ]
            ))
    }
}
