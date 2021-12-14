//
//  DogsWebRepository.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

protocol DogsWebRepository: WebRepository {
    @available(iOS 15.0.0, *)
    func fetchDogLocation() async throws -> Records
}

struct DefaultDogsWebRepository: DogsWebRepository {

    let session: URLSession
    let baseURL: String

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    @available(iOS 15.0.0, *)
    func fetchDogLocation() async throws -> Records {

        let route = Route(
            method: .Get,
            path: Path.Hondenlosloopterreinen.hondenlosloopterreinen,
            headers: ["Accept": "application/json"]
        )

        return try await fetchData(endpoint: route)
    }
}
