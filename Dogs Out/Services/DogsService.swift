//
//  DogsService.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

protocol DogsService {
    @available(iOS 15.0.0, *)
    func fetchDogLocation() async throws -> Records
}

struct DefaultDogsService: DogsService {

    let dogsWebRepository: DogsWebRepository

    init(dogsWebRepository: DogsWebRepository) {
        self.dogsWebRepository = dogsWebRepository
    }

    @available(iOS 15.0.0, *)
    func fetchDogLocation() async throws -> Records {
        return try await dogsWebRepository.fetchDogLocation()
    }
}
