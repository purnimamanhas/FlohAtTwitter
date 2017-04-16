//
//  Tweet+CoreDataProperties.swift
//  
//
//  Created by Created by Purnima on 15/04/17.
//  This file was automatically generated and should not be edited.


import Foundation
import CoreData


extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var avatar: String?
    @NSManaged public var message: String?
    @NSManaged public var name: String?
    @NSManaged public var userName: String?

}
