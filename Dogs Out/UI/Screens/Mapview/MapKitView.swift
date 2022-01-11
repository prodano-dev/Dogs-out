//
//  FooView.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 30/11/2021.
//

import SwiftUI
import MapKit

struct MapKitView: UIViewRepresentable {

    var annotations: [MKPointAnnotation] = []
    @Binding var region: MKCoordinateRegion
    var destinationPoint: CLLocationCoordinate2D
    var transportType: MKDirectionsTransportType
    var showRoute: Bool
    @Binding var selectedPark: Int
    @Binding var zoomLevel: Double


    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
            }
        view.showsUserLocation = true
        //view.region.span = MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
        print(zoomLevel)
        //TODO: - Fix route polyline.
        if showRoute {
            let request = MKDirections.Request()
            request.source = .forCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationPoint))
            request.requestsAlternateRoutes = true
            request.transportType = transportType

            let directions = MKDirections(request: request)

                print("loading....")
                directions.calculate { response, error in
                    if let error = error {
                        print("‼️‼️‼️‼️‼️‼️‼️‼️‼️‼️‼️‼️‼️‼️‼️")
                        print(error.localizedDescription)
                    }
                    guard let unwrappedResponse = response else { return }
                    if let route = unwrappedResponse.routes.first {
                        view.addOverlay(route.polyline)
                        view.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    }
                }
        } else {
            view.removeOverlays(view.overlays)
        }

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapKitView

        init(_ parent: MapKitView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.region.center = mapView.centerCoordinate
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if let deqeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                annotationView = deqeuedView
            } else {
                if !(annotation is MKUserLocation) {
                    annotationView = MKPinAnnotationView(
                        annotation: annotation,
                        reuseIdentifier: identifier
                    )
                    let image = UIImage(systemName: "pawprint.fill")!.withTintColor(.orange)
                    let size = CGSize(width: 25, height: 25)
                    annotationView?.image = UIGraphicsImageRenderer(size:size).image {
                        _ in image.draw(in:CGRect(origin:.zero, size:size))
                    }
                }
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let index = view.annotation?.subtitle {
                parent.selectedPark = Int(index!)!
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .orange
            renderer.lineWidth = 3
            return renderer
        }

    }
}
