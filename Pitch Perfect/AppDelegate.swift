//
//  AppDelegate.swift
//  Pitch Perfect
//
//  Created by leanne on 1/19/16.
//  Copyright © 2016 leanne63. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        removeWavFiles()
    }
    
    // MARK: - Utility Functions
    /**
        Removes .wav files from app's directory.
    */
    func removeWavFiles() {
        // get directories our app is allowed to use
        let pathURLs = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)
        
        // at least one directory must exist for us to continue
		// (note: used this way per Swift Guidelines at: https://github.com/github/swift-style-guide )
		// (could be if, but guard produces compile-time error that'll ensure we're exiting in this case)
        guard pathURLs.count != 0 else {
            return
        }
        
        // we found directories, so grab the first one
        let dirURL = pathURLs[0]
        
        // try to retrieve the contents of the directory
        // if the results are nil, we’ll exit; otherwise we can continue
        //    without implicitly unwrapping our variable (due to guard)
        guard let fileArray = try? FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return
        }
        
        // create a string to describe our sound file’s extension
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", "wav")
        
        // use our file list array to locate file paths with the right extension
        let wavOnlyFileArray = fileArray.filter { predicate.evaluate(with: $0.pathExtension) }
        
        // iterate through each path in our new wav-only file list
        for aWavURL in wavOnlyFileArray {
            do {
                // try removing the current item; if we get an error, catch it
                try FileManager.default.removeItem(at: aWavURL)
            }
            catch {
                // we caught an error, so do something about it
                print("Unable to remove file: \(aWavURL)")
            }
        }
    } // end removeWavFiles()

}
