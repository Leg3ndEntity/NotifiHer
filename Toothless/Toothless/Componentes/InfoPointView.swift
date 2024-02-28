//
//  InfoPointView.swift
//  Toothless
//
//  Created by Alessia Previdente on 28/02/24.
//

import SwiftUI
import MapKit
import CallKit

struct InfoPointView: View {
    @Binding var clicked : Bool
    @Binding var route: MKRoute?
    @Binding var travelTime: String?
    @Binding var selectedResults: MKMapItem?
    
    let stroke = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [8, 8])
    
    var body: some View {
        if selectedResults != nil{
            ZStack{
                Rectangle()
                    .frame(width:400, height: 200)
                    .opacity(0.7)
                    .cornerRadius(20)
                    .foregroundColor(CustomColor.background)
                VStack(alignment: .center){
                    Text("\(selectedResults?.name ?? "")")
                        .font((selectedResults?.name?.count ?? 0 > 21 ? .title2 : .title))
                        .bold()
                        .foregroundStyle(CustomColor.text)
                        .multilineTextAlignment(.center)
                        .frame(width:380)
                    HStack{
                        Text(StringInterestPoint(category: selectedResults?.pointOfInterestCategory ?? .park))
                        Circle()
                            .frame(width: 4, height: 4)
                        if let thoroughfare = selectedResults?.placemark.thoroughfare,
                           let subThoroughfare = selectedResults?.placemark.subThoroughfare {
                            Text("\(thoroughfare) \(subThoroughfare)")
                                .bold()
                                .font(.headline)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        } else {
                            Text("\(selectedResults?.placemark.thoroughfare ?? "")")
                                .bold()
                                .font(.headline)
                                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }
                    }
                    HStack(alignment: .center){
                        ZStack{
                            Rectangle()
                                .frame(width: 70, height: 50)
                                .cornerRadius(10)
                                .foregroundColor(.gray)
                            VStack{
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.white)
                                Text("Call")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                            }
                        }
                        .onTapGesture {
                            let phoneNumber = selectedResults?.phoneNumber?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+39", with: "")
                            let url = URL(string: "tel://\(phoneNumber ?? "")")!
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                        
                        ZStack{
                            Rectangle()
                                .frame(width: 70, height: 50)
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                            VStack{
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.white)
                                
                                if let travelTime {
                                    Text("\(travelTime)")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .onTapGesture {
                            clicked.toggle()
                        }
                    }.padding(.top, 5)
                }.padding(.horizontal, 5)
            }
            .padding(.bottom, -35)
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


