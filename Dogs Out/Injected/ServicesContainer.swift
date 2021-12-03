//
//  ServicesContainer.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation

extension DIContainer {

    struct Services {

        let dogsService: DogsService

        init(dogsService: DogsService) {
            self.dogsService = dogsService
        }
    }
}
