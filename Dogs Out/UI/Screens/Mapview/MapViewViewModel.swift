//
//  MapViewViewModel.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 30/11/2021.
//

import Combine
import SwiftUI
import CoreLocation
import MapKit

extension MapView {

    class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

        @Published var hondenTerrein: [HondenLoopTerrein] = []
        @Published var locationAuthorization: CLAuthorizationStatus = .notDetermined
        private let locationManager = CLLocationManager()
        public let container: DIContainer
        public let cancelBag = Cancellable()
        @Published var transportType: MKDirectionsTransportType = .walking

        init(container: DIContainer) {
            self.container = container
            super.init()
            locationManager.delegate = self
        }

        public func giveLocation() -> CLLocationCoordinate2D {
            return locationManager.location!.coordinate
        }

        public func requestAuthorisation() {
            locationManager.requestWhenInUseAuthorization()
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
                case .authorizedWhenInUse:
                    locationManager.startUpdatingLocation()
                    locationAuthorization = .authorizedWhenInUse
                    break
                case .authorizedAlways:
                    locationManager.startUpdatingLocation()
                    break
                default:
                    break
                }
        }

        public func calculateDistance(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
            request.transportType = transportType

            let directions = MKDirections(request: request)
            directions.calculate { response, err in

                if let routes = response?.routes {
                    let route = routes[0]
                    print(route.distance / 1000)
                }
            }

        }

        @MainActor public func fetchHondenTerrein() async {
            do {
                hondenTerrein = try await container
                    .services
                    .dogsService
                    .fetchDogLocation()
                    .records
            } catch {
                // TODO: Error handling
            }
        }
    }
}
