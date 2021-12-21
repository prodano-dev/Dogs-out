//
//  MapView.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 30/11/2021.
//

import SwiftUI
import MapKit

struct MapView: View {

    @ObservedObject private(set) var viewModel: ViewModel
    @State var selectedPlace: String = ""
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.4396509, longitude: 5.4760529),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State var didChangedTransport = false
    @State var footest = 0.0
    var arrat = [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,3.0]

    var body: some View {

        ZStack {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: viewModel.hondenTerrein
            ) { geolocat in
                MapAnnotation(coordinate: giveLocation(terrein: geolocat.geometry)) {
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(selectedPark(location: geolocat.id) ? Color.orange : Color.black)
                        .onTapGesture {
                            didTappedAnnonation(location: geolocat.id)
                        }
                }
            }
            .ignoresSafeArea()
            .task {
                await viewModel.fetchHondenTerrein()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        didTappedLocationButton()
                    } label: {
                        if viewModel.locationAuthorization == .notDetermined {
                            Image(systemName: "location.fill")
                        } else {
                            switch viewModel.transportType {
                            case .walking:
                                Image(systemName: "figure.walk")
                            case .automobile:
                                Image(systemName: "car.fill")
                            default:
                                Image(systemName: "location.fill")
                            }
                        }
                    }
                    .frame(width: 50, height: 50)
                    .background(Color.black)
                    .cornerRadius(12)
                    .padding()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 1) {
                        ForEach(0..<viewModel.hondenTerrein.count, id:\.self) { index in

                            ParkCell(title:
                                    viewModel.hondenTerrein[index].fields.neighboorHood,
                                     distance: distanceForPark(id: viewModel.hondenTerrein[index].id)
                            )
                                .onTapGesture {
                                    selectedPlace = viewModel.hondenTerrein[index].id

                                }
                                .onChange(of: viewModel.locationAuthorization) { newValue in
                                    calculateDistanceToPark(
                                        parkGeometry: viewModel.hondenTerrein[index].geometry,
                                        id: viewModel.hondenTerrein[index].id
                                    )
                                }
                        }
                    }
                }
                .animation(.default)
            }
        }
    }

    private func didTappedAnnonation(location: String) {
        selectedPlace = location

        if !selectedPark(location: location) {
            selectedPlace = location
        }
    }

    private func distanceForPark(id: String) -> Double {
        guard let distance = viewModel.distances[id] else {
            return 0.0
        }
        return distance
    }

    private func selectedPark(location: String) -> Bool {
        return selectedPlace == location
    }

    public func calculateDistanceToPark(parkGeometry: Geometry, id: String) {
        let end = CLLocationCoordinate2D(
            latitude: parkGeometry.coordinates[1],
            longitude: parkGeometry.coordinates[0]
        )

        viewModel.calculateDistance(
            start: viewModel.giveLocation(),
            end: end,
            id: id)
    }

    func didTappedLocationButton() {
        if viewModel.locationAuthorization == .notDetermined {
            viewModel.requestAuthorisation()
        } else {
            viewModel.transportType = didChangedTransport ? .walking : .automobile
            didChangedTransport.toggle()
        }
    }

    private func giveLocation(terrein: Geometry) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: terrein.coordinates[1],
            longitude: terrein.coordinates[0]
        )
    }
}
