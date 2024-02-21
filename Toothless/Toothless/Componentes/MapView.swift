//
//  MapView.swift
//  Toothless
//
//  Created by Alessia Previdente on 21/02/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var  searchResults: [MKMapItem] = []
    @State private var selectedResults: MKMapItem?
    @State private var route: MKRoute?
    @State var visibleRegion: MKCoordinateRegion?
    let Yuri = CLLocationCoordinate2D(latitude: 40.826823770004644, longitude: 14.196899024494087)
    
    var body: some View {
        Map(selection: $selectedResults){
            UserAnnotation()
            
            ForEach(searchResults, id:\.self){
                result in Marker(item:result)
            }
        }
        .onMapCameraChange {context in
            visibleRegion = context.region
        }
        .onAppear{
            search(for: ["Pharmacy", "Supermarket", "Police Stations", "Hospital"])
        }
        .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
        }
        .mapStyle(.standard(elevation:.realistic))
        .overlay(
                ZStack{
                    Rectangle()
                        .frame(width:380, height: 170)
                        .opacity(0.7)
                        .cornerRadius(20)
                        .foregroundColor(CustomColor.background)
                    VStack(alignment: .center){
                        Text("\(selectedResults?.name ?? "")")
                            .font(selectedResults?.name?.count ?? 0 > 37 ? .title3 : (selectedResults?.name?.count ?? 0 > 21 ? .title2 : .title))
                            .bold()
                            .foregroundStyle(CustomColor.text)
                            .multilineTextAlignment(.center)
                        HStack{
                            Text(StringInterestPoint(category: selectedResults?.pointOfInterestCategory ?? .park))
                        }
                        Text("\(selectedResults?.phoneNumber ?? "")")
                            .bold()
                    }
                    .padding(.bottom, 30)
                    .padding(.leading,3)
                }.padding(.bottom, -35)
                , alignment: .bottom)
    }
    
    func search(for queries: [String]) {
        viewModel.checkIfLocationEnabled()
        
        var combinedItems: [MKMapItem] = []
        
        for query in queries {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.resultTypes = .pointOfInterest
            request.region = visibleRegion ?? viewModel.region
            
            Task {
                let search = MKLocalSearch(request: request)
                let response = try? await search.start()
                combinedItems.append(contentsOf: response?.mapItems ?? [])
                searchResults = combinedItems
            }
        }
    }

    func StringInterestPoint(category: MKPointOfInterestCategory) -> String {
            switch category {
            case .pharmacy:
                return "Pharmacy"
            case .hospital:
                return "Hospital"
            case .police:
                return "Police Stations"
            case .restaurant:
                return "Restaurant"
            case .foodMarket:
                return "Supermarket"
            default:
                return ""
            }
        }
}

#Preview {
    MapView()
}

