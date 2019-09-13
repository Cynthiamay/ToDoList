//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Treinamento on 9/4/19.
//  Copyright © 2019 cynthiamayumiwatanabeyamaoto. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
//        let data = Data()
//        data.name = "Cynthia"
//        data.age = 23
//
        do{
            _ = try Realm()
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        
        
        
        return true
    }
}
