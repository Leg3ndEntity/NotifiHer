//
//  ToothlessApp.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import SwiftUI

@main
struct Toothless_provaApp: App {
    @StateObject var healthKitManager = HealthKitManager()
    @StateObject var viewModel = MapViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            Toothless()
                .environmentObject(healthKitManager)
                .onAppear{viewModel.checkIfLocationEnabled()
                }
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if granted {
                            print("Autorizzazione alle notifiche ottenuta")
                        } else {
                            print("Autorizzazione alle notifiche negata")
                        }
                    }
                }
        }
        
    }
}
