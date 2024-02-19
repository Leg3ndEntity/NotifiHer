//
//  HealthKitManager.swift
//  Toothless
//
//  Created by Simone Sarnataro on 16/02/24.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject, ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var heightValue: Double = 0.0
    @Published var weightValue: Double = 0.0
    
    override init() {
        super.init()
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit non è disponibile su questo dispositivo.")
            completion(false)
            return
        }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                print("HealthKit autorizzato.")
                completion(true)
            } else {
                print("Failed to authorize HealthKit: \(error?.localizedDescription ?? "")")
                completion(false)
            }
        }
    }
    
    func fetchHeight() {
        let heightType = HKObjectType.quantityType(forIdentifier: .height)!
        let heightQuery = HKSampleQuery(sampleType: heightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let height = samples.first?.quantity.doubleValue(for: HKUnit.meter()) else {
                print("Failed to fetch height: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.heightValue = height
                print("Height: \(height)")
            }
        }
        healthStore.execute(heightQuery)
    }
    
    func fetchWeight() {
        let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let weightQuery = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample], let weight = samples.first?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo)) else {
                print("Failed to fetch weight: \(error?.localizedDescription ?? "")")
                return
            }
            DispatchQueue.main.async {
                self.weightValue = weight
                print("Weight: \(weight)")
            }
        }
        healthStore.execute(weightQuery)
    }
    
}
