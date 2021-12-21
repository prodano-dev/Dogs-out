//
//  HondenLosLoopTerrein.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation

struct HondenLoopTerrein: Codable, Equatable, Identifiable {

    let id: String
    let fields: Fields
    let geometry: Geometry


    enum CodingKeys: String, CodingKey {
        case id = "recordid"
        case fields = "fields"
        case geometry = "geometry"
    }

}

struct Fields: Codable, Equatable {

    let surface: Double
    let geoPoint: [Double]
    let neighboorHood: String

    enum CodingKeys: String, CodingKey {
        case surface = "oppervlakt"
        case geoPoint = "geo_point_2d"
        case neighboorHood = "buurt"

    }
}

struct Geometry: Codable, Equatable {

    let coordinates: [Double]

}

struct Records: Codable, Equatable {

    let records: [HondenLoopTerrein]

    enum CodingKeys: String, CodingKey {
        case records = "records"
    }
}
