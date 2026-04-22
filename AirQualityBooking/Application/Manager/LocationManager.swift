//
//  LocationManager.swift
//  AirQualityBooking
//
//  Created by Praveen on 22/04/26.
//

import Foundation
import MapKit
import Observation

enum LocationManagerError: LocalizedError {
    case authorizationDenied
    case authorizationRestricted
    case unknownLocations
    case accessDenied
    case operationfailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied: return "Authorization Denied"
        case .authorizationRestricted: return "Authorization Restricted"
        case .unknownLocations: return "Unknown Locations"
        case .accessDenied: return "Access Denied"
        case .operationfailed: return "Operation Failed"
        case .unknown: return "Unknown Error"
        }
    }
}

@Observable class LocationManager: NSObject {
    static let shared = LocationManager()
    let manager = CLLocationManager()
    var region = MKCoordinateRegion()
    var error : LocationManagerError? = nil
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            error = .authorizationRestricted
        case .denied:
            error = .authorizationDenied
        @unknown default:
            error = .unknown
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                self.error = .unknownLocations
            case .denied:
                self.error = .accessDenied
            case .network:
                self.error = .operationfailed
            default :
                self.error = .unknown
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(center: $0.coordinate, latitudinalMeters: 0.5, longitudinalMeters: 0.5)
        }
    }
}

extension MKCoordinateRegion: @retroactive Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center.latitude == rhs.center.latitude && lhs.center.longitude == rhs.center.longitude && lhs.span.latitudeDelta == rhs.span.latitudeDelta && lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
