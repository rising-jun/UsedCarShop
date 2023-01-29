//
//  CarShopAPI.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/29.
//

import Foundation

enum CarShopAPI {
    case carShop
    case carInfo(id: Int)
}
extension CarShopAPI: TargetAPI {
    var baseURL: String {
        "https://www.carshop.com"
    }
    
    var path: String {
        switch self {
        case .carShop:
            return "/carshop"
        case .carInfo(_):
            return "/carInfo"
        }
    }
    
    var method: Method {
        switch self {
        case .carShop:
            return .get
        case .carInfo(_):
            return .get
        }
    }
    
    var parameters: [String: Any?]? {
        switch self {
        case .carShop:
            return nil
        case .carInfo(let id):
            return ["id": id]
        }
    }
}

protocol TargetAPI {
    var baseURL: String { get }
    var path: String { get }
    var method: Method { get }
    var parameters: [String: Any?]? { get }
}
extension TargetAPI {
    func makeCompleteURL() -> URL? {
        var urlString = self.baseURL + self.path
        switch self.method {
        case .get:
            let withParameterURLString = urlString + "?" + "\(appendParameter() ?? "")"
            return URL(string: urlString)
        case .delete, .post, .update:
            return URL(string: urlString)
        }
    }
    
    private func appendParameter() -> String? {
        guard var urlComponents = URLComponents(string: self.baseURL) else { return nil }
            urlComponents.queryItems = appendQueryItems()
            return urlComponents.query
    }
    
    private func appendQueryItems() -> [URLQueryItem] {
        if let parameter = self.parameters {
            var queryItems = [URLQueryItem]()
            for key in parameter.keys {
                if let value = parameter[key] as? String {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
            }
            return queryItems
        }
        return []
    }
}

enum Method {
    case get
    case post
    case update
    case delete
}
