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
    @State var location = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
    @State private var locations = [MKPointAnnotation]()

    var body: some View {

        MapKitView(centerCoordinate: $location, annotations: locations)
        .onAppear {
            viewModel.fetchHondenTerrein()
        }
        .onChange(of: viewModel.hondenTerrein) { newValue in
            for terrein in 0..<newValue.count {
                setLocations(terrein: newValue[terrein].geometry)
            }
        }

    }

    private func setLocations(terrein: Geometry) {
        let location = CLLocationCoordinate2D(
            latitude: terrein.coordinates[1],
            longitude: terrein.coordinates[0]
        )
        let newLocation = MKPointAnnotation()
        newLocation.coordinate = location
        self.locations.append(newLocation)
    }
}
