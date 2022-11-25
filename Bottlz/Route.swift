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

    /// Compute the coordinates of a location that is partially through the route geometry
    /// - Parameter fraction: Proportion of the route geometry that the point is beyond
    /// - Returns: Smoothed position that is `fraction` along the route, capped at route endpoints
    func position(fraction: Double) -> CLLocationCoordinate2D {
        guard fraction <= 1.0 else {
            return route.last!
        }
        guard fraction >= 0.0 else {
            return route.first!
        }

        var edgeLengths: [Double] = []
        for i in 1..<route.count {
            let dLat = route[i].latitude - route[i - 1].latitude
            let dLon = route[i].longitude - route[i - 1].longitude
            let length = (dLat * dLat + dLon * dLon).squareRoot()
            edgeLengths.append(length)
        }

        let totalLength = edgeLengths.reduce(0, +)
        let coveredLength = fraction * totalLength

        var accumulatedLength = 0.0
        var currentEdgeIndex = 0
        for i in 0..<edgeLengths.count {
            if accumulatedLength + edgeLengths[i] > coveredLength {
                currentEdgeIndex = i
                break
            }
            accumulatedLength += edgeLengths[i]
        }

        let currentEdgeTraveledLength = coveredLength - accumulatedLength
        let currentEdgeFraction = currentEdgeTraveledLength / edgeLengths[currentEdgeIndex]

        let currentPoint = route[currentEdgeIndex]
        let nextPoint = route[currentEdgeIndex + 1]

        let interpolatedLatitude = currentPoint.latitude
            + (nextPoint.latitude - currentPoint.latitude) * currentEdgeFraction
        let interpolatedLongitude = currentPoint.longitude
            + (nextPoint.longitude - currentPoint.longitude) * currentEdgeFraction

        return CLLocationCoordinate2D(latitude: interpolatedLatitude, longitude: interpolatedLongitude)
    }

    private enum CodingKeys: String, CodingKey {
        case distance
        case routeRaw = "route"
    }
}

struct RouteAnnotation: Identifiable {
    var id: String
    var point: CLLocationCoordinate2D
    var portion: Double
}
