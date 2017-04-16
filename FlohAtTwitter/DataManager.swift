//
//  DataManager.swift
//  FlohAtTwitter
//
//  Created by Purnima on 15/04/17.
//  Copyright © 2017 Purnima. All rights reserved.

import CoreData
import CoreLocation
var counter: Int = 0
class DataManager: NSObject {
    private static var __once: DataManager = {
        
        return DataManager()
    }()
    class var sharedInstance: DataManager {
        
        struct Static {
            static var onceToken: Int = 0
            static var instance: DataManager? = nil
        }
        Static.instance = DataManager.__once
        return Static.instance!
    }
    
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        let modelURL = Bundle.main.url(forResource: "FlohAtTwitter", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("FlohAtTwitter.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch {
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func fetchTweets() -> [Tweet]? {
        
        var fetchedTweet: [Tweet]?
        let tweetEntity = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")

        do {
            fetchedTweet = try (self.managedObjectContext.fetch(tweetEntity) as? [Tweet])

            self.saveContext()
        } catch {
            fatalError("Failed to fetch tweets: \(error)")
        }
        return fetchedTweet
    }
    
    
    func deleteTweets() {
        
        let tweetEntity = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        tweetEntity.includesPropertyValues = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: tweetEntity)
        
        do {
            try persistentStoreCoordinator.execute(deleteRequest, with: self.managedObjectContext)
            self.saveContext()

        } catch {
            fatalError("Failed to delete tweets: \(error)")
        }
    }
    
    func saveTweet(_ name: String!, username: String!, message: String!, image: String!) {
        
        let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweet", into: self.managedObjectContext) as! Tweet
        
        tweet.name = name
        tweet.userName = username
        tweet.message = message
        tweet.avatar = image
        counter += 1
        
        self.saveContext()
    }
}

