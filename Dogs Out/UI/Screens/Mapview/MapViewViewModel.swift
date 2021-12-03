//
//  MapViewViewModel.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 30/11/2021.
//

import Combine
import SwiftUI

extension MapView {

    class ViewModel: ObservableObject {

        @Published var hondenTerrein: [HondenLoopTerrein] = []
        public let container: DIContainer
        public let cancelBag = Cancellable()

        init(container: DIContainer) {
            self.container = container
        }

        public func fetchHondenTerrein() {

            container
                .services
                .dogsService
                .fetchDogLocation()
                .sink(receiveCompletion: { err in
                    print(err)
                }, receiveValue: { result in
                    self.hondenTerrein = result.records
                })
                .store(in: cancelBag)
        }
    }
}
