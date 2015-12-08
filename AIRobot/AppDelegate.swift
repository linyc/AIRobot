//
//  AppDelegate.swift
//  AIRobot
//
//  Created by yuecang on 15/12/7.
//  Copyright © 2015年 LINYC. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        Parse.setApplicationId("V5qnd5XILb5oWTpKTwEWXhXx5h4YUPBzSd2DFgca", clientKey: "OmKfCdu7q6rmbX9aufYEvF9Ue6Rqy8JpRrO943A7")
//        var query = PFQuery(className: "Messages")
//        query.orderByAscending("sendDate")
//        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//            for object in objects! as [PFObject]{
//                let incoming:Bool = object["incoming"] as! Bool
//                let text:String = object["text"] as! String
//                let sentDate:NSDate = object["sentDate"] as! NSDate
//                print("\(object.objectId!)\n\(incoming)\n\(text)\n\(sentDate)");
//            }
//        }
        
        var chatVC:ViewController = ViewController()
        chatVC.title = "AIRobot"
        
        UINavigationBar.appearance().tintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.05, green: 0.47, blue: 0.91, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        var navigationVC:UINavigationController = UINavigationController(rootViewController: chatVC)
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        window!.rootViewController = navigationVC
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

