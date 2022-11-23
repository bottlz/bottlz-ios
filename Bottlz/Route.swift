//
//  Route.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/21/22.
//

import CoreLocation

struct Route: Codable {
    var distance: Double
    var routeRaw: [[Double]]
    var route: [CLLocationCoordinate2D]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.distance = try container.decode(Double.self, forKey: .distance)
        self.routeRaw = try container.decode([[Double]].self, forKey: .routeRaw)
        self.route = self.routeRaw.map { pointPair in
            CLLocationCoordinate2D(latitude: pointPair[1], longitude: pointPair[0]) }
    }

    private enum CodingKeys: String, CodingKey {
        case distance
        case routeRaw = "route"
    }
}
