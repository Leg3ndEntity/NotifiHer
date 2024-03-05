//
//  MapView.swift
//  Toothless
//
//  Created by Alessia Previdente on 21/02/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    private let stroke = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [5, 5])
    @State var clicked : Bool = false
    @StateObject private var viewModel = MapViewModel()
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResults: MKMapItem?
    @State private var travelTime: String?
    @State private var route: MKRoute?
    @State var visibleRegion: MKCoordinateRegion?
    @State private var position: MapCameraPosition = .userLocation(
        followsHeading: true,
        fallback: .automatic
    )
    var body: some View {
            Map(position: $position, selection: $selectedResults) {
                UserAnnotation()
                ForEach(searchResults, id:\.self) {
                    result in Marker(item: result)
                }
                if clicked {
                    MapPolyline(route!.polyline)
                        .stroke(.blue, style: stroke)
                }
            }
            .safeAreaInset(edge: .bottom) {
                InfoPointView(clicked: $clicked, route: $route, travelTime: $travelTime, selectedResults: $selectedResults)
            }
            .onMapCameraChange { context in
                visibleRegion = context.region
            }
            .onAppear {
                // Request location authorization when the MapView appears
                viewModel.checkLocationAuthorization()
                search(for: ["Pharmacy", "Supermarket", "Police Stations", "Hospital"])
            }
            .onChange(of: searchResults) {
                position = .userLocation(
                    followsHeading: true,
                    fallback: .automatic
                )
            }
            .onChange(of: selectedResults) {
                fetchRouteFrom((viewModel.locationManager?.location!.coordinate)!, to: (selectedResults?.placemark.coordinate)!)
            }
            .mapControls {
                MapUserLocationButton()
            }
            .mapStyle(.standard(elevation: .realistic))
            // Add a tap gesture to request location authorization when the map is tapped
            .gesture(TapGesture().onEnded {
                viewModel.checkLocationAuthorization()
            })
        }
    }



extension MapView{
    func search(for queries: [String]) {
        viewModel.checkIfLocationEnabled()
        
        var combinedItems: [MKMapItem] = []
        
        for query in queries {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.resultTypes = .pointOfInterest
            request.region = visibleRegion ?? viewModel.region
            
            /*MKCoordinateRegion(center: (viewModel.locationManager?.location!.coordinate)!, span: MapDetails.defaultSpan)*/
            
            Task {
                let search = MKLocalSearch(request: request)
                let response = try? await search.start()
                combinedItems.append(contentsOf: response?.mapItems ?? [])
                searchResults = combinedItems
            }
        }
    }
    private func fetchRouteFrom(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .walking
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            getTravelTime()
        }
    }
    
    private func getTravelTime() {
        guard let route else { return }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        travelTime = formatter.string(from: route.expectedTravelTime)
    }
}

#Preview {
    MapView()
}

