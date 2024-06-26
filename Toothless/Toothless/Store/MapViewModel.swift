//
//  MapViewModel.swift
//  Toothless
//
//  Created by Alessia Previdente on 19/02/24.
//

import MapKit

enum MapDetails{
    static let startingLocation = CLLocationCoordinate2D(latitude: 40.828210908059106 , longitude: 14.19339120503187)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)

    var locationManager: CLLocationManager?

    func checkIfLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            checkLocationAuthorization()
        } else {
            print("alert: location is off, need to turn it on")
        }
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("location restricted")
        case .denied:
            print("location denied")
        case .authorizedAlways, .authorizedWhenInUse:
            if let userLocation = locationManager.location {
                region = MKCoordinateRegion(center: userLocation.coordinate, span: MapDetails.defaultSpan)
                print("User location retrived:\(region)")
            } else {
                print("User location not available yet")
            }
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
