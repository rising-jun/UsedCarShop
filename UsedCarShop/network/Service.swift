//
//  CarShopService.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import Foundation

final class Service {
    func fetchMockJson(by api: TargetAPI) async -> Result<Data, NetworkError> {
        guard let url = api.makeCompleteURL() else { return .failure(.invailURL) }
        return await withCheckedContinuation({ [weak self] continuation in
            URLSession.shared.dataTask(with: url) { _, response, error in
                guard let self = self else {
                    continuation.resume(returning: .failure(.nilSelf))
                    return
                }
                if api.path == "/carshop" {
                    guard let data = self.fetchMockCarShop() else {
                        return continuation.resume(returning: .failure(.notFound))
                    }
                    return continuation.resume(returning: .success(data))
                }
                if api.path == "/carinfo" {
                    print("hello?")
                    guard let parameter = api.parameters,
                          let id = parameter["id"] as? String else {
                        return continuation.resume(returning: .failure(.notFound))
                    }
                    
                    guard let data = self.fecthMockCarDetail(by: id) else {
                        continuation.resume(returning: .failure(.notFound))
                        return
                    }
                    
                    continuation.resume(returning: .success(data))
                    return
                }

                if let _ = error {
                    continuation.resume(returning: .failure(.response))
                    return
                }
                continuation.resume(returning: .failure(.response))
            }.resume()
        })
    }
}
private extension Service {
    func fetchMockCarShop() -> Data? {
        guard let data = self.loadJSON(Service.self, fileName: "CarShop") else {
            return nil
        }
        return data
    }
    
    func fecthMockCarDetail(by id: String) -> Data? {
        guard let data = self.loadJSON(Service.self, fileName: "CarInfo") else {
            return nil
        }
        let carDTOs = try? JSONDecoder().decode([CarDTO].self, from: data)
        let findCarDTOs = carDTOs?.compactMap { $0 }.filter { $0.zones.contains { $0 == id } }
        let jsonData = try? JSONEncoder().encode(findCarDTOs)
        return jsonData
    }
    
    func loadJSON(_ loadClass: AnyClass, fileName: String) -> Data? {
        guard let path = Bundle.init(for: loadClass).path(forResource: fileName, ofType: "json") else {
            print("--- file not found : \(fileName).json")
            return nil
        }
        let fileURL = URL(fileURLWithPath: path)
        guard let data = try? Data.init(contentsOf: fileURL) else {
            print("--- can not access the file : \(fileName).json")
            return nil
        }
        return data
    }
}
