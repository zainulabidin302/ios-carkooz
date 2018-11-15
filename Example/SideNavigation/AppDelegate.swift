//
//  AppDelegate.swift
//  Carkooz
//
//  Created by apple on 10/28/18.
//  Copyright © 2018 Tendril. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var isMenuHidden = true
    static var location: CLLocationCoordinate2D?
    static var loc: (lat: String, long: String) {
        get {
            return (
                String(Double((AppDelegate.location?.latitude)!))
                ,String(Double((AppDelegate.location?.longitude)!))
            )
        }
    }
    static var baseURL = "https://carkooz.com/database/"
    static var imagesBaseUrl = "https://carkooz.com/images/"
    static var chatServerUrl = "http://localhost:3002/"
    
    static var user: [String: Any]? = nil

    
    static func toQueryParmas(_ dict: [String: String?]) -> String {
        let res = dict.map { (key, value) in
            return key + "=" + value!
        }
        return res.joined(separator: "&")
    }

    static func showToast(message: String, duration: Double, controller: UIViewController, buttonText: String? = "Cancel") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            controller.present(alert, animated: true)
            // duration in seconds
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                alert.dismiss(animated: true)
            }

        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

