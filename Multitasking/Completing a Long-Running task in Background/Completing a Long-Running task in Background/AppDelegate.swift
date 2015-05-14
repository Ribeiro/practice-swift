//
//  AppDelegate.swift
//  Completing a Long-Running task in Background
//
//  Created by Domenico Solazzo on 14/05/15.
//  License MIT
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Background task identifier
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier =
    UIBackgroundTaskInvalid
    
    // Timer
    var myTimer: NSTimer?
    
    // Check if multitasking is supported
    func isMultitaskingSupported() -> Bool{
        return UIDevice.currentDevice().multitaskingSupported
    }
    
}
