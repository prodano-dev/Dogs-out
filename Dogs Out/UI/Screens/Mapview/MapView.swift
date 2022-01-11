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
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.4396509, longitude: 5.4760529),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State var showRoute = false
    @State var selectedPark = 0
    @State var showCenterIcon = false

    var body: some View {

        ZStack {
            MapKitView(
                annotations: locations,
                region: $region,
                destinationPoint: viewModel.parkDestination,
                transportType: viewModel.transportType,
                showRoute: showRoute,
                selectedPark: $selectedPark
            )
                .task {
                    await viewModel.fetchHondenTerrein()
                }
                .onChange(of: viewModel.hondenTerrein) { newValue in
                    for terrein in 0..<newValue.count {
                        setLocations(
                            terrein: newValue[terrein].geometry,
                            title: newValue[terrein].fields.neighboorHood,
                            index: terrein
                        )
                    }
                }
                .onChange(of: region.center.latitude) { newValue in
                   showCenterIcon = true
                    if newValue == viewModel.centerLocation.latitude {
                        showCenterIcon = false
                    }
                }
            VStack {
                Spacer()
                if showCenterIcon {

                    HStack {
                        Spacer()
                        Button {
                            region.center = viewModel.centerLocation
                        } label: {
                            Image(systemName: "location.viewfinder")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .frame(width: 50, height: 50)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
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

                ScrollViewReader { scrollviewReader in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            ForEach(0..<viewModel.hondenTerrein.count, id:\.self) { index in

                                ParkCell(title:
                                        viewModel.hondenTerrein[index].fields.neighboorHood,
                                         distance: viewModel.distanceForPark(id: viewModel.hondenTerrein[index].id, distanceOrTime: 0),
                                         timeTravel: viewModel.distanceForPark(id: viewModel.hondenTerrein[index].id, distanceOrTime: 1),
                                         onTap: {
                                    showRoute.toggle()
                                    viewModel.parkDestination = giveLocation(terrein: viewModel.hondenTerrein[index].geometry)

                                }, navigating: showRoute)
                                    .onTapGesture {
                                        didTappedCell(at: index)
                                    }
                                    .onChange(of: viewModel.locationAuthorization) { newValue in
                                        Task {
                                            //await viewModel.calculatefoo(index: index)
                                            viewModel.calculateDistance(
                                            parkGeometry: viewModel.hondenTerrein[index].geometry,
                                            id: viewModel.hondenTerrein[index].id)
                                        }
                                    }
                                    .onChange(of: viewModel.transportType) { newValue in
                                        Task {
                //                                        await viewModel.calculatefoo(index: index)
                                            viewModel.calculateDistance(
                                            parkGeometry: viewModel.hondenTerrein[index].geometry,
                                            id: viewModel.hondenTerrein[index].id)
                                        }
                                    }
                                    .onChange(of: selectedPark) { newValue in
                                        withAnimation(.easeIn(duration: 5.5)) {
                                            scrollviewReader.scrollTo(selectedPark)
                                        }
                                    }
                            }
                        }
                    }
                }
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

    private func setLocations(terrein: Geometry, title: String, index: Int) {
        let location = CLLocationCoordinate2D(
            latitude: terrein.coordinates[1],
            longitude: terrein.coordinates[0]
        )
        let newLocation = MKPointAnnotation()
        newLocation.coordinate = location
        newLocation.title = title
        newLocation.subtitle = String(index)
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
