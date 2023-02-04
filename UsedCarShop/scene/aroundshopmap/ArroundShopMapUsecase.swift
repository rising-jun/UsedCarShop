//
//  ArroundShopMapUsecase.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/29.
//

import Foundation

final class ArroundShopMapUsecase {
    private let permissionManager = PermissionManager()
    private let repository = CarShopRespository()
    
    func requestUserLocation() async -> (Location?, LocationPermission) {
        return await withCheckedContinuation { [weak self] continuation in
            guard let self = self else { return }
            permissionManager.updateLocation = { lat, lng in
                continuation.resume(returning: (Location(lat: lat, lng: lng), .available))
                self.permissionManager.updateLocation = nil
            }
            
            permissionManager.whenPermissionDeniend = {
                continuation.resume(returning: (Location(lat: 0.0, lng: 0.0), .unavailable))
                self.permissionManager.whenPermissionDeniend = nil
            }
            permissionManager.requestUseLocationPermission()
        }
    }
    
    func requestCarShopModel() async -> [CarShopDTO]? {
        return await repository.requestMockCarShop()
    }
}
