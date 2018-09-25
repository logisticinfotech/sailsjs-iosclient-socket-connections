//
//  AppDelegate.swift
//  SocketDemo
//
//  Created by Bhavin on 02/07/18.
//  Copyright © 2018 Logistic Infotech PVT LTD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentUserId:Int? = nil
    var dictChatHistory = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.goToMainScreen()
        return true
    }
    
    func goToMainScreen(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = StoryBoards.SDCreateUserSB.instantiateViewController(withIdentifier: "SDNavCreateUser") as! UINavigationController
        //        let initialViewController = StoryBoards.SDUserListSB.instantiateViewController(withIdentifier: "SDNavUserList") as! UINavigationController
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        SocketManagerTest.sharedInstance.emitChangeUserStatusSocketSubscribe(strStatus: UserStatus.offline.rawValue) { (response) in
//        }
        _ = SocketManagerTest.sharedInstance.closeConnection()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Your code with delay
        
//        SocketManagerTest.sharedInstance.emitChangeUserStatusSocketSubscribe(strStatus: UserStatus.online.rawValue) { (response) in}
//        if let objTopVc = topViewController(){
//            if objTopVc.childViewControllers.count > 1{
//                if objTopVc.childViewControllers[1] is SDUserListVC{
//                    (objTopVc.childViewControllers[1] as! SDUserListVC).getOnlineUserList()
//                }
//            }
//        }
        if let objTopVc = topViewController(){
            if objTopVc.childViewControllers.count > 1{
                if objTopVc.childViewControllers[1] is SDUserListVC{
                    self.goToMainScreen()
                }
            }
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

