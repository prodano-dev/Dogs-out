//
//  WebRepository.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

protocol WebRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension WebRepository {

    @available(iOS 15.0.0, *)
    public func fetchData(endpoint: Route) async throws -> Records {
        let request = try endpoint.urlRequest(baseURL: baseURL)
        let url = try endpoint.justUrl(baseUrl: baseURL)
        do {

            let (data, response) = try await URLSession.shared.data(from: url)
            let records = try JSONDecoder().decode(Records.self, from: data)
            return records
        } catch {
            throw error
        }
    }
}
