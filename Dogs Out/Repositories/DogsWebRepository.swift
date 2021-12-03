//
//  DogsWebRepository.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

protocol DogsWebRepository: WebRepository {
    func fetchDogLocation() -> AnyPublisher<Records, APIError>
}

struct DefaultDogsWebRepository: DogsWebRepository {

    let session: URLSession
    let baseURL: String

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchDogLocation() -> AnyPublisher<Records, APIError> {

        let route = Route(
            method: .Get,
            path: Path.Hondenlosloopterreinen.hondenlosloopterreinen,
            headers: ["Accept": "application/json"]
        )


        return fetchData(endpoint: route)
    }
}
