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
        return await withCheckedContinuation { continuation in
            permissionManager.updateLocation = { lat, lng in
                print("arround usecase closure \(lat) \(lng)")
                continuation.resume(returning: (Location(lat: lat, lng: lng), .available))
            }
            
            permissionManager.whenPermissionDeniend = {
                continuation.resume(returning: (Location(lat: 0.0, lng: 0.0), .unavailable))
            }
            
            permissionManager.requestUseLocationPermission()
        }
    }
    
    func requestCarShopModel() async -> [CarShopDTO]? {
        print("request carshop")
        return await repository.requestMockCarShop()
    }
}
