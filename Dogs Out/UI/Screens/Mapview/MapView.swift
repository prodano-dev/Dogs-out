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
    @State var didChangedTransport = false
    @State private var locations = [MKPointAnnotation]()

    var body: some View {

        ZStack {
            MapKitView(
                annotations: locations,
                centerCoordinate: viewModel.$region.center,
                destinationPoint: viewModel.parkDestination,
                transportType: viewModel.transportType
            )
                .task {
                    await viewModel.fetchHondenTerrein()
                }
                .onChange(of: viewModel.hondenTerrein) { newValue in
                                 for terrein in 0..<newValue.count {
                                     setLocations(
                                         terrein: newValue[terrein].geometry,
                                         title: newValue[terrein].fields.neighboorHood
                                     )
                                 }
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
                                     distance: viewModel.distanceForPark(id: viewModel.hondenTerrein[index].id, distanceOrTime: 0),
                                     timeTravel: viewModel.distanceForPark(id: viewModel.hondenTerrein[index].id, distanceOrTime: 1),
                                     onTap: {
                                viewModel.parkDestination = giveLocation(terrein: viewModel.hondenTerrein[index].geometry)

                            })
                                .onTapGesture {
                                    didTappedCell(at: index)

                                }
                                .onChange(of: viewModel.locationAuthorization) { newValue in
                                    viewModel.calculateDistance(
                                        parkGeometry: viewModel.hondenTerrein[index].geometry,
                                        id: viewModel.hondenTerrein[index].id)
                                }
                                .onChange(of: viewModel.transportType) { newValue in
                                    viewModel.calculateDistance(
                                        parkGeometry: viewModel.hondenTerrein[index].geometry,
                                        id: viewModel.hondenTerrein[index].id)
                                }
                        }
                    }
                }
                .animation(.default)
            }
        }
    }

    private func didTappedCell(at: Int) {
        viewModel.selectedPlace = viewModel.hondenTerrein[at].id
    }

    private func didTappedAnnonation(location: String) {
        viewModel.selectedPlace = location

        if !viewModel.selectedPark(location: location) {
            viewModel.selectedPlace = location
        }
    }

    private func setLocations(terrein: Geometry, title: String) {
             let location = CLLocationCoordinate2D(
                 latitude: terrein.coordinates[1],
                 longitude: terrein.coordinates[0]
             )
             let newLocation = MKPointAnnotation()
             newLocation.coordinate = location
             newLocation.title = title
             self.locations.append(newLocation)
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
