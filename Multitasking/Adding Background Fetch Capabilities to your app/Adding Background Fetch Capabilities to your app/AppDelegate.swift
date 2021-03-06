//
//  AppDelegate.swift
//  Adding Background Fetch Capabilities to your app
//
//  Created by Domenico Solazzo on 14/05/15.
//  License MIT
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // News items
    var newsItems = [NewsItem]()
    
    func applicationDidFinishLaunching(application: UIApplication) {
        // Adding a news item as soon the app starts
        newsItems.append(NewsItem(date:NSDate(), text: "NewsItem 1"))
        
        // Set the background interval for fetching new content
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
    }
    
    /**
        It gets called in your app delegate when iOS wants your app 
        to fetch new content in the background. 
        Call the completion handler when you are done.
    **/
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        println("\(__FUNCTION__): Trying to fetch new items...")
        if (self.fetchItems()){
        
            completionHandler(UIBackgroundFetchResult.NewData)
        }else{
            // If there is not data, you need to call it with .NoData parameter.
            completionHandler(UIBackgroundFetchResult.NoData)
        }
    }
    
    // Name of the notification when a news item is available
    func newsItemsChangedNotification() -> String{
        return "\(__FUNCTION__)"
    }
    
    /* Mock function: Returns true if it could get some news items from the server */
    func fetchItems() -> Bool{
        println("\(__FUNCTION__): Looking for new items...")
        var coin = arc4random_uniform(2) // 0 or 1
        if(coin != 1){
            println("\(__FUNCTION__): No data")
            return false
        }
        
        println("\(__FUNCTION__): New data is available...")
        // Generate new item
        let item = NewsItem(date: NSDate(), text: "News Item \(newsItems.count + 1)")
        newsItems.append(item)
        
        /* Send a notification to observers telling them that a news item
        is now available */
        let notificationName = self.newsItemsChangedNotification()
        NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil)
        return true
        
    }
}

