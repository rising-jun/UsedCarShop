//
//  CarShopService.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/28.
//

import RxSwift

final class Service {
    func fetchMockCarShopJson(by api: TargetAPI) async -> Result<Data, NetworkError> {
        guard let url = api.makeCompleteURL() else { return .failure(.invailURL) }
        return await withCheckedContinuation({ [weak self] continuation in
            URLSession.shared.dataTask(with: url) { _, response, error in
                guard let self = self else {
                    continuation.resume(returning: .failure(.nilSelf))
                    return
                }
                if api.path == "/carshop" {
                    guard let data = self.loadJSON(Service.self, fileName: "CarShop") else {
                        return continuation.resume(returning: .failure(.notFound))
                    }
                    return continuation.resume(returning: .success(data))
                }
                if api.path == "/carinfo" {
                    guard let data = self.loadJSON(Service.self, fileName: "CarInfo") else {
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
    
    private func loadJSON(_ loadClass: AnyClass, fileName: String) -> Data? {
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


enum NetworkError: Error {
    case nilSelf
    case notFound
    case invailURL
    case response
    case jsonParsing
}
