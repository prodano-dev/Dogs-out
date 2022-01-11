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

        private let locationManager = CLLocationManager()
        public let container: DIContainer
        public let cancelBag = Cancellable()
        @Published var transportType: MKDirectionsTransportType = .walking
        @Published var hondenTerrein: [HondenLoopTerrein] = []
        @Published var locationAuthorization: CLAuthorizationStatus = .notDetermined
        @Published var distances: [String: [Double]] = [:]
        var selectedPlace: String = ""
        var parkDestination: CLLocationCoordinate2D = CLLocationCoordinate2D()

        init(container: DIContainer) {
            self.container = container
            super.init()
            locationManager.delegate = self
        }

        public func giveLocation() -> CLLocationCoordinate2D {
            guard let userLocation = locationManager.location?.coordinate
            else { return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
            return userLocation
        }

        public func requestAuthorisation() {
            locationManager.requestWhenInUseAuthorization()
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
                case .authorizedWhenInUse:
                    locationManager.startUpdatingLocation()
                    locationAuthorization = .authorizedWhenInUse
                case .authorizedAlways:
                    locationManager.startUpdatingLocation()
                default:
                    break
                }
        }

        public func calculateDistance(index: Int) async {
            let end = CLLocationCoordinate2D(
                latitude: hondenTerrein[index].geometry.coordinates[1],
                longitude: hondenTerrein[index].geometry.coordinates[0]
            )
            let id = hondenTerrein[index].id

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: giveLocation()))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
            request.transportType = transportType

            let directions = MKDirections(request: request)

            do {
                self.distances[id] = try await [directions
                    .calculate()
                    .routes
                    .first!
                    .distance/1000,
                    directions
                        .calculate()
                        .routes
                        .first!
                        .expectedTravelTime/60.rounded()]
            } catch {
                print(error.localizedDescription)
            }
        }

        public func calculateDistance(parkGeometry: Geometry, id: String) {
            let end = CLLocationCoordinate2D(
                latitude: parkGeometry.coordinates[1],
                longitude: parkGeometry.coordinates[0]
            )

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: giveLocation()))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
            request.transportType = transportType


            let directions = MKDirections(request: request)

            //TODO: - Change to async function.
            directions.calculate { response, err in

                if let routes = response?.routes {
                    if let route = routes.first {
                        self.distances[id] = [
                            route.distance / 1000,
                            (route.expectedTravelTime / 60).rounded()
                        ]
                    }
                }
            }
        }

        public func selectedPark(location: String) -> Bool {
            return selectedPlace == location
        }

        public func distanceForPark(id: String, distanceOrTime: Int) -> Double {
            guard let distance = distances[id] else {
                return 0.0
            }
            return distance[distanceOrTime]
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
