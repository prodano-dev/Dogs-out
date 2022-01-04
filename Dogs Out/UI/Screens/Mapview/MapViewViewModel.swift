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
        @Published var distances: [String: Double] = [:]
        var selectedPlace: String = ""
        @State var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.4396509, longitude: 5.4760529),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
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
                    let route = routes[0]
                    self.distances[id] = route.distance / 1000
                    self.hondenTerrein[0].distance = 34
                    
                }
            }
        }

        public func selectedPark(location: String) -> Bool {
            return selectedPlace == location
        }

        public func distanceForPark(id: String) -> Double {
            guard let distance = distances[id] else {
                return 0.0
            }
            return distance
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
