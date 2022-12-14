//
//  Bottle.swift
//  Bottlz
//
//  Created by Changyuan Lin on 11/5/22.
//

import Foundation
import MapKit

struct Bottle: Codable, Identifiable {
    static let speed = 1.0

    var id: UUID
    var created: Date

    private var originRaw: GeoPoint?
    var origin: CLLocationCoordinate2D
    private var endpointRaw: GeoPoint?
    var endpoint: CLLocationCoordinate2D

    var routes: [Route]

    init(lat: Double, lon: Double) {
        self.init(id: UUID(), created: Date(), lat: lat, lon: lon)
    }

    init(id: UUID, created: Date, lat: Double, lon: Double) {
        self.id = id
        self.created = created
        self.origin = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.endpoint = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.routes = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.created = try container.decode(Date.self, forKey: .created)
        self.originRaw = try container.decode(Bottle.GeoPoint.self, forKey: .originRaw)
        self.origin = CLLocationCoordinate2D(latitude: originRaw!.coordinates[1],
                                             longitude: originRaw!.coordinates[0])
        self.endpointRaw = try container.decode(Bottle.GeoPoint.self, forKey: .endpointRaw)
        self.endpoint = CLLocationCoordinate2D(latitude: endpointRaw!.coordinates[1],
                                             longitude: endpointRaw!.coordinates[0])
        self.routes = try container.decode([Route].self, forKey: .routes)
    }

    var routeAnnotations: [RouteAnnotation] {
        routes.enumerated().flatMap { (routeIndex, route) in
            route.route.enumerated().map { (pointIndex, point) in
                RouteAnnotation(id: "\(self.id):\(routeIndex):\(pointIndex)",
                                point: point, portion: Double(pointIndex) / Double(route.route.count))
            }
        }
    }

    func isOutOfRoutes(currentDate: Date) -> Bool {
        let coveredDistance = currentDate.timeIntervalSince(self.created) * Bottle.speed
        let totalRouteDistance = routes.map({ route in route.distance }).reduce(0, +)
        return coveredDistance >= totalRouteDistance
    }

    func computeCurrentLocation(currentDate: Date) -> CLLocationCoordinate2D {
        guard !routes.isEmpty else { return origin }
        guard !isOutOfRoutes(currentDate: currentDate) else { return endpoint }

        let coveredDistance = currentDate.timeIntervalSince(self.created) * Bottle.speed

        var accumulatedDistance = 0.0
        var currentRouteIndex = routes.count - 1
        for i in 0..<routes.count {
            if accumulatedDistance + routes[i].distance > coveredDistance {
                currentRouteIndex = i
                break
            }
            accumulatedDistance += routes[i].distance
        }

        let currentRouteTraveledDistance = coveredDistance - accumulatedDistance
        let currentRouteFraction = currentRouteTraveledDistance / routes[currentRouteIndex].distance
        print("currentRouteIndex:\(self.id):\(currentRouteIndex)")
        print("currentRouteFraction:\(self.id):\(currentRouteFraction)")

        return routes[currentRouteIndex].position(fraction: currentRouteFraction)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case created
        case originRaw = "origin"
        case endpointRaw = "endpoint"
        case routes
    }

    private struct GeoPoint: Codable {
        var type: String
        var coordinates: [Double]
    }
}
