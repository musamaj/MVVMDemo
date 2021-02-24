//
//  NSCategory+CoreDataClass.swift
//  
//
//  Created by Usama Jamil on 21/10/2019.
//
//

import Foundation
import CoreData

@objc(NSCategory)
public class NSCategory: NSManagedObject {

    
    static var selectedCategory        : NSCategory?
    static var categories              = [NSCategory]()
    
    static var fetchId                 : String?
    
    
    class func saveCategory(_ category: CategoryData, byOWner: Bool = false) {
        
        //Minion Context worker with Private Concurrency type.
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = PersistenceManager.sharedInstance.getMainContextInstance()
        
        let item = NSEntityDescription.insertNewObject(forEntityName: NSCategory.identifier,
                                                       into: PersistenceManager.sharedInstance.getMainContextInstance()) as! NSCategory
        
        item.id                    = category.id
        item.serverId              = category.id
        item.name                  = category.name
        
        if byOWner {
            item.ownerId               = category.owner?.id
            item.ownerName             = category.owner?.name
            item.ownerEmail            = category.owner?.email
        } else {
            item.ownerId               = Persistence.shared.currentUserID
            item.ownerName             = Persistence.shared.currentUserUsername
            item.ownerEmail            = Persistence.shared.currentUserEmail
        }
        item.synced                = category.synced
        item.createdAt             = category.createdAt
        
        //Save current work on Minion workers
        //PersistenceManager.sharedInstance.saveWorkerContext(minionManagedObjectContextWorker)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func updateByPredicate(_ category: CategoryData, byServer: Bool = true) {
        
//        let minionManagedObjectContextWorker: NSManagedObjectContext =
//            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//        minionManagedObjectContextWorker.parent = PersistenceManager.sharedInstance.getMainContextInstance()
        
        //self.fetchId    = category.fetchId
        self.categories = getCategories(false, sortAscending: false, byPredicate: true)
        if self.categories.count > 0 {
            self.selectedCategory = categories[0]
        }
        
        self.selectedCategory?.name = category.name
        
        if let id = category.id {
            
            if byServer {
                self.selectedCategory?.serverId = id
            }
            self.selectedCategory?.createdAt = category.createdAt
            self.selectedCategory?.updatedAt = category.updatedAt
            self.selectedCategory?.synced    = true
        }
        
        
        //Persist new Event to datastore (via Managed Object Context Layer).
       // PersistenceManager.sharedInstance.saveWorkerContext(minionManagedObjectContextWorker)
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
        if TasksListVM.selectedCategory?.id == self.selectedCategory?.id {
            TasksListVM.selectedCategory = category
        }
        
    }
    
    
    class func updateCategory(_ category: CategoryData, _ byServer: Bool = true) {
        
//        let minionManagedObjectContextWorker: NSManagedObjectContext =
//            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//        minionManagedObjectContextWorker.parent = PersistenceManager.sharedInstance.getMainContextInstance()
        
        self.selectedCategory?.name = category.name
        
        if let id = category.id {
            
            if byServer {
                self.selectedCategory?.serverId  = id
            }
            self.selectedCategory?.createdAt = category.createdAt
            self.selectedCategory?.updatedAt = category.updatedAt
            self.selectedCategory?.synced    = true
        }
        
        
        //Persist new Event to datastore (via Managed Object Context Layer).
        //PersistenceManager.sharedInstance.saveWorkerContext(minionManagedObjectContextWorker)
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func saveCategories(_ categories: [CategoryData]) {
        
        //Minion Context worker with Private Concurrency type.
//        let minionManagedObjectContextWorker: NSManagedObjectContext =
//            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//        minionManagedObjectContextWorker.parent = PersistenceManager.sharedInstance.getMainContextInstance()
        
        for category in categories {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: NSCategory.identifier,
                                                           into: PersistenceManager.sharedInstance.getMainContextInstance()) as! NSCategory
            
            item.serverId              = category.id
            item.id                    = category.id
            item.createdAt             = category.createdAt
            item.name                  = category.name
            item.ownerId               = category.owner?.id
            item.ownerName             = category.owner?.name
            item.ownerEmail            = category.owner?.email
            item.updatedAt             = category.updatedAt
            item.synced                = category.synced
            
            self.categories.append(item)
            
            //Save current work on Minion workers
            //PersistenceManager.sharedInstance.saveWorkerContext(minionManagedObjectContextWorker)
        }
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
    }
    
    class func deleteCategory(_ item: NSCategory) {
        
        //Delete event item from persistance layer
        PersistenceManager.sharedInstance.getMainContextInstance().delete(item)
        
        //Save and merge changes from Minion workers with Main context
        PersistenceManager.sharedInstance.mergeWithMainContext()
        
    }
    
    class func getCategories(_ sortedByDate: Bool = true, sortAscending: Bool = false, byPredicate: Bool = false) -> [NSCategory] {
        
        var fetchedResults = [NSCategory]()
        
        // Create request on Event entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: NSCategory.identifier)
        
        //Create sort descriptor to sort retrieved Events by Date, ascending
        if sortedByDate {
            let sortDescriptor = NSSortDescriptor(key: "createdAt",
                                                  ascending: sortAscending)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
            
            let predicate1 = NSPredicate(format: "rowDeleted == %@", false)
            fetchRequest.predicate = predicate1
        }
        
        if byPredicate {
            let predicate1 = NSPredicate(format: "id == %@", self.fetchId ?? "")
            let predicate2 = NSPredicate(format: "serverId == %@", self.fetchId ?? "")
            let compound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate1, predicate2])
            fetchRequest.predicate = compound
        }
        
        //Execute Fetch request
        do {
            fetchedResults = try  PersistenceManager.sharedInstance.getMainContextInstance().fetch(fetchRequest) as! [NSCategory]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = [NSCategory]()
        }
        
        return fetchedResults
    }
    
}