//
//  AppDelegate.swift
//  Destini
//
//  Created by Juliano Santos on 7/1/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new Realm \(error)")
        }
        
        return true
    }

}

