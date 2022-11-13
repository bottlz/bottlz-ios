//
//  LocationManager.swift
//  Bottlz
//
//  Created by Changyuan Lin on 10/28/22.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private static let DefaultLocation = CLLocationCoordinate2D(latitude: 42.45, longitude: -76.48)
    private let locationManager = CLLocationManager()

    var currentLocation: CLLocationCoordinate2D {
        guard let location = self.locationManager.location else {
            return LocationManager.DefaultLocation
        }
        return location.coordinate
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager changed the status: \(status)")
    }
}
