//
//  CoreDataManager.swift
//  SampleCalendar
//
//  Created by ram on 02/07/15.
//  Copyright (c) 2015 XYZ. All rights reserved.
//

import UIKit
import CoreData

let UpdatedModelNotification : String = "com.samplecalendar.updated"
let DeletedModelNotification : String = "com.samplecalendar.deleted"
let InsertedModelNotification : String = "com.samplecalendar.inserted"

let UpdatedModelKey = NSUpdatedObjectsKey
let DeletedModelKey = NSDeletedObjectsKey
let InsertedModelKey = NSInsertedObjectsKey

class CoreDataManager: NSObject {
    
    
    class var sharedInstance: CoreDataManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CoreDataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CoreDataManager()
        }
        return Static.instance!
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleDataModelChange:"), name: NSManagedObjectContextObjectsDidChangeNotification, object: self.managedObjectContext)

    }
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xyz.CoreData" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.LibraryDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CalendarModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CoreData.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func addNote(title:String, noteDescripton:String, date : NSDate, color:UIColor){
        let newNote : Note = NSEntityDescription.insertNewObjectForEntityForName("Note", inManagedObjectContext: self.managedObjectContext!) as! Note
        newNote.title = title
        newNote.createdOn = date
        newNote.color = color
        newNote.noteDescription = noteDescripton
        var error: NSError?
        self.managedObjectContext?.save(&error)
        
    }
    
    func modifyNote(note:Note, title:String, noteDescripton:String, date : NSDate, color:UIColor){
       
        note.title = title
        note.createdOn = date
        note.color = color
        note.noteDescription = noteDescripton
        var error: NSError?
        self.managedObjectContext?.save(&error)
        
    }
    
    func getNote(dated: NSDate) -> (note:Note?,found:Bool) {
        let entityDescription = NSEntityDescription.entityForName("Note",inManagedObjectContext: self.managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        let pred = NSPredicate(format: "(createdOn = %@)", dated)
        request.predicate = pred
        var error: NSError?
        var objects = self.managedObjectContext?.executeFetchRequest(request,error: &error)
        
        if let results = objects {
            
            if results.count > 0 {
                let match = results[0] as! Note
                return(match,true)
            } else {
                return(nil,false)
            }
        }
        return(nil,false)
    }
    
    func getNotesBetween(beginDate:NSDate ,endDate:NSDate)->[Note]{
        
        let entityDescription = NSEntityDescription.entityForName("Note",inManagedObjectContext: self.managedObjectContext!)
        let request = NSFetchRequest()
        request.entity = entityDescription
        let pred = NSPredicate(format: "(createdOn >= %@ && createdOn <= %@)", beginDate,endDate)
        request.predicate = pred
        var error: NSError?
        var objects = self.managedObjectContext?.executeFetchRequest(request,error: &error) as! [Note]
        return objects
    }
    
    func deleteNote(note:Note){
        self.managedObjectContext?.deleteObject(note)
        var error: NSError?
        self.managedObjectContext?.save(&error)
    }
    
    func handleDataModelChange(notification:NSNotification){
        if let info : Dictionary = notification.userInfo as? Dictionary<String,AnyObject>{
            if let insertedObjects: AnyObject  = info[NSInsertedObjectsKey]{
                NSNotificationCenter.defaultCenter().postNotificationName(InsertedModelNotification, object: self.managedObjectContext, userInfo: info)
            }
            if let updatedObjects: AnyObject = info[NSUpdatedObjectsKey]{
                NSNotificationCenter.defaultCenter().postNotificationName(UpdatedModelNotification, object: self.managedObjectContext, userInfo: info)
            }
            if let deletedObjects: AnyObject = info[NSDeletedObjectsKey]{
                NSNotificationCenter.defaultCenter().postNotificationName(DeletedModelNotification, object: self.managedObjectContext, userInfo: info)
            }

        }
        
    }
    
    

}
