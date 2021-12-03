//
//  DIContainer.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 25/11/2021.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {

    let services: Services
    static var defaultValue: Self { self.defaultValue }

    init(sevices: DIContainer.Services) {
        self.services = sevices
    }
}

extension DIContainer {
    struct WebRepositories {
        let dogsWebRepository: DogsWebRepository
    }
}
