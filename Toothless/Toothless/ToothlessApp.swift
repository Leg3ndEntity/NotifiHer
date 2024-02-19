//
//  ToothlessApp.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import SwiftUI

@main
struct ToothlessApp: App {
    @StateObject private var viewModel = MapViewModel()
    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .onAppear{viewModel.checkIfLocationEnabled()
                }
        }
    }
}
