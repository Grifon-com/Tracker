//
//  AppDelegate.swift
//  Tracker
//
//  Created by Григорий Машук on 28.09.23.
//

import UIKit
import CoreData
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var container: NSPersistentContainer {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DaysValueTransformer.register()
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: YandexApiKey.apiKeyYMM) else { return true }
        YMMYandexMetrica.activate(with: configuration)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

