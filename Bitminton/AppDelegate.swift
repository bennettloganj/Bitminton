//
//  AppDelegate.swift
//  Bitminton
//
//  Created by LunarLincoln on 5/16/17.
//  Copyright © 2017 LunarLincoln. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let defaults = UserDefaults.standard
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        if let key = UserDefaults.standard.object(forKey: "scoreArray"){
            //do nothing the arrays already exists
        }
        else{
            let scoreArray = Array(repeating: 0, count: 13)
            defaults.set(scoreArray, forKey: "scoreArray")
        }
        
        if let key = UserDefaults.standard.object(forKey: "nameArray"){
            // do nothing
        }
        else{
            let nameArray: [String] = Array(repeating: "---", count: 13)
            defaults.set(nameArray, forKey: "nameArray")
        }
        
        if let key = UserDefaults.standard.object(forKey: "hasInitializedBirdieImages") {
            
        }
        else{
            let hasInitializedBirdieImages = true
            defaults.set(hasInitializedBirdieImages, forKey: "hasInitializedBirdieImages")
            
            let newImage = UIImage(named: "NewBirdie")
            let defaultImage = UIImage(named: "PlainBirdieYellow")
            let defaultImageData: NSData = UIImageJPEGRepresentation(defaultImage!, 1.0)! as NSData
            let newImageData: NSData = UIImageJPEGRepresentation(newImage!, 1.0)! as NSData
            
            let entity =  NSEntityDescription.insertNewObject(forEntityName: "Birdie", into: context) as! Birdie
            entity.birdieImage = newImageData
            
            let entity2 =  NSEntityDescription.insertNewObject(forEntityName: "Birdie", into: context) as! Birdie
            entity2.birdieImage = defaultImageData
            
            
            do{
                try context.save()
            } catch {
                print("Failed to save")
            }
        }
        
        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Bitminton")
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






