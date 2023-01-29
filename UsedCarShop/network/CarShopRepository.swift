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
        let result = await service.fetchMockCarShopJson(by: CarShopAPI.carShop)
        switch result {
        case .success(let data):
            guard let carShops = jsonDecode(decodeType: [CarShopDTO].self, data: data) else {
                print("jsonparsing error ")
                return nil
            }
            return carShops
        case .failure(let error):
            print("error \(error)")
        }
        return nil
    }
    
    private func jsonDecode<T: Decodable>(decodeType: T.Type, data: Data) -> T? {
        return try? JSONDecoder().decode(decodeType, from: data)
    }
}
