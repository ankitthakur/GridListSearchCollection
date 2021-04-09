//
//  AppDelegate.swift
//  GridListSearchCollection
//
//  Created by Ankit Thakur on 09/04/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NetworkManager.shared.setUp()
        
        let searchModule = IMDBSearchRouter()
        searchModule.build()
        guard let moduleViewController = searchModule.navigationViewController else {return true}
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = moduleViewController
        window?.makeKeyAndVisible()
        return true
    }

}

