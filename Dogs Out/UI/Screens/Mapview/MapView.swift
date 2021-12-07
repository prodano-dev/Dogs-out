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
    @State var location = CLLocationCoordinate2D(latitude: 51.4396509, longitude: 5.4760529)
    @State private var locations = [MKPointAnnotation]()
    @State var selectedPlace: String = ""
    @State var coordination = CLLocationCoordinate2D()

    var body: some View {

        ZStack {
            MapKitView(
                centerCoordinate: $location,
                annotations: locations,
                title: $selectedPlace,
                coordiante: $coordination
            )
            .ignoresSafeArea()
            .onAppear {
                viewModel.fetchHondenTerrein()
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

                    } label: {
                        Image(systemName: "location.fill")
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
                        }
                    }
                }
            }
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
}
