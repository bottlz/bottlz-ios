//
//  Bottle.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/5/22.
//

import Foundation
import MapKit

struct Bottle: Codable, Identifiable {
    var id: UUID
    var created: Date

    private var originRaw: GeoPoint
    var origin: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: originRaw.coordinates[0], longitude: originRaw.coordinates[1])
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case created
        case originRaw = "origin"
    }

    private struct GeoPoint: Codable {
        var type: String
        var coordinates: [Double]
    }
}
