//
//  AppDelegate.swift
//  AlynProto
//
//  Created by Alex Agarkov on 03.04.2021.
//

import UIKit
import CoreData
import CareKit

import CareKitStore
import HealthKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy private(set) var coreDataStore = OCKStore(name: "AlynProtoStore", type: .onDisk)
    lazy private(set) var storeManager = OCKSynchronizedStoreManager(wrapping: coreDataStore)
    
    let healthStore = HKHealthStore()
    
    lazy private(set) var synchronizedStoreManager: OCKSynchronizedStoreManager = OCKSynchronizedStoreManager.init(wrapping: coreDataStore)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if HKHealthStore.isHealthDataAvailable() {
            // Add code to use HealthKit here.
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
                                HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!, // Scalar(Percent, 0.0 - 1.0),  Discrete
                                HKObjectType.quantityType(forIdentifier: .height)!, // Length,                      Discrete
                                HKObjectType.quantityType(forIdentifier: .bodyMass)!, // Mass,                        Discrete
                                HKObjectType.quantityType(forIdentifier: .leanBodyMass)!, // Mass,                        Discrete
                                HKObjectType.quantityType(forIdentifier: .waistCircumference)!, // Length,                      Discrete
                                HKObjectType.quantityType(forIdentifier: .stepCount)!, // Scalar(Count),               Cumulative
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, // Length,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!, // Length,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .distanceWheelchair)!, // Length,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!, // Energy,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, // Energy,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!, // Scalar(Count),               Cumulative
                                HKObjectType.quantityType(forIdentifier: .pushCount)!, // Scalar(Count),               Cumulative
                                HKObjectType.quantityType(forIdentifier: .distanceSwimming)!, // Length,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .swimmingStrokeCount)!, // Scalar(Count),               Cumulative
                                HKObjectType.quantityType(forIdentifier: .vo2Max)!, // ml/(kg*min)                  Discrete
                                HKObjectType.quantityType(forIdentifier: .distanceDownhillSnowSports)!, // Length,                      Cumulative
                                HKObjectType.quantityType(forIdentifier: .walkingSpeed)!, // m/s,                         Discrete
                                HKObjectType.quantityType(forIdentifier: .walkingDoubleSupportPercentage)!, // Scalar(Percent, 0.0 - 1.0),Discrete
                                HKObjectType.quantityType(forIdentifier: .walkingStepLength)!, // Length,                      Discrete
                                HKObjectType.quantityType(forIdentifier: .sixMinuteWalkTestDistance)!, // Length,                      Discrete
                                HKObjectType.quantityType(forIdentifier: .stairAscentSpeed)!, // m/s,                         Discrete
                                HKObjectType.quantityType(forIdentifier: .stairDescentSpeed)!, // m/s),                        Discrete
                                HKObjectType.quantityType(forIdentifier: .heartRate)!, // Scalar(Count)/Time,          Discrete
                                HKObjectType.quantityType(forIdentifier: .bodyTemperature)!, // Temperature,                 Discrete
                                HKObjectType.quantityType(forIdentifier: .basalBodyTemperature)!, // Basal Body Temperature,      Discrete
                                HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)!, // Pressure,                    Discrete
                                HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic)!, // Pressure,                    Discrete
                                HKObjectType.quantityType(forIdentifier: .respiratoryRate)!, // Scalar(Count)/Time,          Discrete
                                HKObjectType.quantityType(forIdentifier: .restingHeartRate)!, // Scalar(Count)/Time,          Discrete
                                HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!, // Time (ms),                   Discrete
                                HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!, // Scalar(Percent, 0.0 - 1.0),  Discrete
                                HKObjectType.quantityType(forIdentifier: .peripheralPerfusionIndex)!, // Scalar(Percent, 0.0 - 1.0),  Discrete
                                HKObjectType.quantityType(forIdentifier: .bloodGlucose)!, // Mass/Volume,                 Discrete
                                HKObjectType.quantityType(forIdentifier: .numberOfTimesFallen)!, // Scalar(Count),               Cumulative
                                HKObjectType.quantityType(forIdentifier: .electrodermalActivity)!, // Conductance,                 Discrete
                                HKObjectType.quantityType(forIdentifier: .inhalerUsage)!, // Scalar(Count),               Cumulative
                                HKObjectType.quantityType(forIdentifier: .insulinDelivery)!, // Pharmacology (IU)            Cumulative
                                HKObjectType.quantityType(forIdentifier: .bloodAlcoholContent)!, // Scalar(Percent, 0.0 - 1.0),  Discrete
                                HKObjectType.quantityType(forIdentifier: .forcedVitalCapacity)!, // Volume,                      Discrete
                                HKObjectType.quantityType(forIdentifier: .forcedExpiratoryVolume1)!, // Volume,                      Discrete
                                HKObjectType.quantityType(forIdentifier: .peakExpiratoryFlowRate)!, // Volume/Time,                 Discrete
                                HKObjectType.quantityType(forIdentifier: .environmentalAudioExposure)!, // Pressure,                    DiscreteEquivalentContinuousLevel
                                HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure)!, // Pressure,                    DiscreteEquivalentContinuousLevel
                                HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryFatPolyunsaturated)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryFatMonounsaturated)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryCholesterol)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietarySodium)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryFiber)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietarySugar)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!, // Energy, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryProtein)!, // Mass,   Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminA)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminC)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminD)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminE)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryVitaminK)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryCalcium)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryIron)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryThiamin)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryRiboflavin)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryNiacin)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryFolate)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryBiotin)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryPantothenicAcid)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryIodine)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryMagnesium)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryZinc)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietarySelenium)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryCopper)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryManganese)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryChromium)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryMolybdenum)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryChloride)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryPotassium)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!, // Mass, Cumulative
                                HKObjectType.quantityType(forIdentifier: .dietaryWater)! // Volume, Cumulative
//                                HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
//                                HKObjectType.categoryType(forIdentifier: .cervicalMucusQuality)!, // HKCategoryValueCervicalMucusQuality
//                                HKObjectType.categoryType(forIdentifier: .ovulationTestResult)!, // HKCategoryValueOvulationTestResult
//                                HKObjectType.categoryType(forIdentifier: .menstrualFlow)!, // HKCategoryValueMenstrualFlow
//                                HKObjectType.categoryType(forIdentifier: .intermenstrualBleeding)!, // (Spotting) HKCategoryValue
//                                HKObjectType.categoryType(forIdentifier: .sexualActivity)!, // HKCategoryValue
//                                HKObjectType.categoryType(forIdentifier: .mindfulSession)!, // HKCategoryValue
//                                HKObjectType.categoryType(forIdentifier: .toothbrushingEvent)!, // HKCategoryValue
//                                HKObjectType.categoryType(forIdentifier: .pregnancy)!, // HKCategoryValue
//                                HKObjectType.categoryType(forIdentifier: .lactation)!, // HKCategoryValue
            ]) // HKCategoryValueSeverity // Scalar(Count), Discrete

            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                }
            }
        }
        let plan:OCKCarePlan = OCKCarePlan.init(id: "ID", title: "Title", patientID: nil)
        coreDataStore.addCarePlan(plan)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "AlynProto")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

