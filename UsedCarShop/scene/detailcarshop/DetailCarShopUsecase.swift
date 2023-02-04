//
//  DetailCarShopUsecase.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/02/04.
//

import Foundation

final class DetailCarShopUsecase {
    var repository = CarShopRespository()
    func requestDetailCars(by id: String) async -> [CarDTO]? {
        return await repository.requestMockDetailCars(by: id)
    }
}
private extension DetailCarShopUsecase {
    
}
