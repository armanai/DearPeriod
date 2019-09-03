//
//  AppDelegate.swift
//  DearPeriod
//
//  Created by Armana Imširević, Klara Raškaj on 14/11/2018.
//  Copyright © 2018 Armana Imširević, Klara Raškaj. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let userDataKey:String = "PersonData"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let decoder = JSONDecoder()
        
        if let savedPerson = UserDefaults.standard.object(forKey: userDataKey) as? Data, let person = try? decoder.decode(Person.self, from: savedPerson){
            if let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "Home") as? UINavigationController, let homeViewController = homeNavigationController.viewControllers.first as? HomeViewController{
                homeViewController.person = person
                self.window?.rootViewController = homeNavigationController
            }
        }else{
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "Onboarding")
        }
    
        //UserDefaults.standard.set(nil, forKey: userDataKey)
        
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
    }


}

