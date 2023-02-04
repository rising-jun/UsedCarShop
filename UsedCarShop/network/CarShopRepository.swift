//
//  CarShopRepository.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/29.
//

import Foundation

final class CarShopRespository {
    let service = Service()
    
    func requestMockCarShop() async -> [CarShopDTO]? {
        let result = await service.fetchMockJson(by: CarShopAPI.carShop)
        return await verifyResult(with: result, decodeType: [CarShopDTO].self)
    }
    
    func requestMockDetailCars(by carshopId: String) async -> [CarDTO]? {
        let result = await service.fetchMockJson(by: CarShopAPI.carInfo(id: carshopId))
        return await verifyResult(with: result, decodeType: [CarDTO].self)
    }
}
private extension CarShopRespository {
    func verifyResult<T: Decodable>(with result: Result<Data, NetworkError>, decodeType: T.Type) async -> T? {
        switch result {
        case .success(let data):
            guard let cars = jsonDecode(decodeType: decodeType, data: data) else {
                //TODO go to error jsonparsing
                print("json error")
                return nil
            }
            return cars
        case .failure(let error):
            print("error \(error)")
            //TODO go to error
        }
        return nil
    }
    
    func jsonDecode<T: Decodable>(decodeType: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(decodeType, from: data)
    }
}
