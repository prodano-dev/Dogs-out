//
//  DogsService.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import Combine

protocol DogsService {
    func fetchDogLocation() -> AnyPublisher<Records, APIError>
}

struct DefaultDogsService: DogsService {

    let dogsWebRepository: DogsWebRepository

    init(dogsWebRepository: DogsWebRepository) {
        self.dogsWebRepository = dogsWebRepository
    }

    func fetchDogLocation() -> AnyPublisher<Records, APIError> {
        return dogsWebRepository.fetchDogLocation()
    }
}
