//
//  AppDelegate.swift
//  Journal
//
//  Created by JinSeo Yoon on 2018. 7. 21..
//  Copyright © 2018년 Jinseo Yoon. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        customizeNavigationBar()
        injectEnvironment()
        
        return true
    }
    
    private func injectEnvironment() {
        guard
            let navViewController = window?.rootViewController as? UINavigationController,
            let timelineViewController = navViewController.topViewController as? TimelineViewController
            else { return }
        
        let realm = try! Realm(configuration: Realm.Configuration())
        let realmEntryRepo = RealmEntryRepository(realm: realm)
        let env = Environment(
            entryRepository: realmEntryRepo,
            entryFactory: { text in
                let entry = RealmEntry()
                entry.uuidString = UUID().uuidString
                entry.createdAt = Date()
                entry.text = text
                return entry
            },
            settings: UserDefaults.standard)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!) // /Users/rinndash/Library/Developer/CoreSimulator/Devices/075DECA8-1562-4792-8D84-F9CAD42E33B1/data/Containers/Data/Application/3E42DEF9-D4FF-4465-A9C5-5E6561364699/Documents/default.realm
        
        timelineViewController.viewModel = TimelineViewControllerModel(environment: env)
    }
    
    private func customizeNavigationBar() {
        guard let navViewController = window?.rootViewController as? UINavigationController else { return }
        
        navViewController.navigationBar.prefersLargeTitles = true
        navViewController.navigationBar.barStyle = .black
        
        let bgimage = UIImage.gradientImage(with: [.gradientStart, .gradientEnd], size: CGSize(width: UIScreen.main.bounds.size.width, height: 1))
        
        navViewController.navigationBar.barTintColor = UIColor(patternImage: bgimage!)
        navViewController.navigationBar.tintColor = UIColor.white
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

