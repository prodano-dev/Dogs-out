//
//  FooView.swift
//  Dogs Out
//
//  Created by Danny Prodanovic on 30/11/2021.
//

import SwiftUI
import MapKit

struct MapKitView: UIViewRepresentable {

    typealias Context = UIViewRepresentableContext<Self>
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation] = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
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

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.image = UIImage(systemName: "pawprint.fill")
                annotationView?.canShowCallout = true

                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {

                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }

}
