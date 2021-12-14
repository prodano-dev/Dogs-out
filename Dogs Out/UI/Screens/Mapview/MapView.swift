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
                                        viewModel.hondenTerrein[index].fields.neighboorHood
                            )
                                .onTapGesture {
                                    selectedPlace = viewModel.hondenTerrein[index].id
                                    calculate(loca: viewModel.hondenTerrein[index].geometry)
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

    public func calculate(loca: Geometry) {
        let end = CLLocationCoordinate2D(
            latitude: loca.coordinates[1],
            longitude: loca.coordinates[0]
        )

        viewModel.calculateDistance(
            start: viewModel.giveLocation(),
            end: end)

    }

    private func selectedPark(location: String) -> Bool {
        return selectedPlace == location
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
