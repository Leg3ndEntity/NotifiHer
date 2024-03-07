//
//  FakeCallsViewModel.swift
//  Toothless
//
//  Created by Alessia Previdente on 04/03/24.
//

import Foundation
class FakeCallsViewModel{
    var fakecall = [
     FakeCall(situation: "Taxi/Uber", duration: "15 min", imagename: "Taxi", video: "VideoProva3"),
     FakeCall(situation: NSLocalizedString("Public Transportation", comment: ""), duration: "10 min", imagename: "Public Transportation", video: "VideoProva3"),
     FakeCall(situation: NSLocalizedString("Walking Alone", comment: ""), duration: "10 min", imagename: "Walking", video: "VideoProva3"),
     FakeCall(situation: "Taxi/Uber", duration: "15 min", imagename: "Taxi", video: "VideoProva3"),
     FakeCall(situation: NSLocalizedString("Public Transportation", comment: ""), duration: "10 min", imagename: "Public Transportation", video: "VideoProva3"),
     FakeCall(situation: NSLocalizedString("Walking Alone", comment: ""), duration: "10 min", imagename: "Walking", video: "VideoProva3")
    ]
}
