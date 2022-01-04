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
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var destinationPoint: CLLocationCoordinate2D
    var transportType: MKDirectionsTransportType


    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        let region = MKCoordinateRegion(
            center: centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        mapView.setRegion(region, animated: true)

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
            }
        view.showsUserLocation = true

        //TODO: - Fix route polyline.
        if !destinationPoint.latitude.isZero {
            let request = MKDirections.Request()
            request.source = .forCurrentLocation()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationPoint))
            request.requestsAlternateRoutes = true
            request.transportType = transportType

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let unwrappedResponse = response else { return }
                if let route = unwrappedResponse.routes.first {
                    view.addOverlay(route.polyline)
                    view.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
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
            parent.centerCoordinate = mapView.centerCoordinate
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
                    annotationView?.image = UIImage(systemName: "pawprint.fill")
                }
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .orange
            renderer.lineWidth = 3
            return renderer
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        }

        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            view.image = UIImage(systemName: "pawprint.fill")
        }
    }
}
