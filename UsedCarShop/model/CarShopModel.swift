//
//  CarShopModel.swift
//  UsedCarShop
//
//  Created by 김동준 on 2023/01/29.
//

import Foundation

struct CarShopDTO: Codable, Equatable, Any {
    let id, name, alias: String
    let location: Location
}

struct Location: Codable {
    let lat, lng: Double
}
extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return (lhs.lat == rhs.lat && lhs.lng == rhs.lng)
    }
}

struct CarDTO: Codable {
    let id, name, doodleDTODescription: String
    let imageURL: String
    let category: String
    let zones: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case doodleDTODescription = "description"
        case imageURL = "imageUrl"
        case category, zones
    }
}

struct FavoriteZone: Codable {
    let name: String
    let alias: String
}
extension FavoriteZone {
    static let key: String = "FavoriteZone"
}

enum CarCategory: String {
    case EV = "EV"
    case COMPACT = "COMPACT"
    case COMPACT_SUV = "COMPACT_SUV"
    case SEMI_MID_SUV = "SEMI_MID_SUV"
    case SEMI_MID_SEDAN = "SEMI_MID_SEDAN"
    case MID_SUV = "MID_SUV"
    case MID_SEDAN = "MID_SEDAN"
    
    var name: String {
        switch self {
        case .EV:
            return "전기"
        case .COMPACT:
            return "소형"
        case .COMPACT_SUV:
            return "소형 SUV"
        case .SEMI_MID_SUV:
            return "준중형 SUV"
        case .SEMI_MID_SEDAN:
            return "준중형 세단"
        case .MID_SUV:
            return "중형 SUV"
        case .MID_SEDAN:
            return "중형 세단"
        }
    }
}
