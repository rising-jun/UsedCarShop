//
//  PermissionManager.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import CoreLocation
import Foundation

final class PermissionManager: NSObject {
    var whenPermissionDeniend: (() -> ())?
    var updateLocation: ((Double, Double) -> ())?
    private let locationManager = CLLocationManager()
    private var updateLocationDispatchItem: DispatchWorkItem?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
}
extension PermissionManager: CLLocationManagerDelegate {
    func requestUseLocationPermission() {
        reactLocationPermission(with: checkLocationPermission())
    }
    
    private func reactLocationPermission(with status: LocationPermission) {
        switch status {
        case .shouldRequest:
            requestLocationPermission()
        case .available:
            locationManager.startUpdatingLocation()

        case .unavailable:
            whenPermissionDeniend?()
        }
    }
    
    private func checkLocationPermission() -> LocationPermission {
        return CLLocationManager.authorizationStatus().canUsePermission()
    }
    
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        reactLocationPermission(with: status.canUsePermission())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.updateLocation?(location.coordinate.latitude, location.coordinate.longitude)
    }
}

@frozen enum LocationPermission: Equatable {
    case shouldRequest
    case available
    case unavailable
}

extension CLAuthorizationStatus {
    func canUsePermission() -> LocationPermission {
        switch self {
        case .notDetermined:
            return .shouldRequest
        case .restricted, .denied:
            return .unavailable
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            return .available
        }
    }
}
