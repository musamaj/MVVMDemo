//
//  CategoryListingVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import SVProgressHUD


class CategoryListingVM: NSObject {

    
    // MARK:- Properties
    
    
    var categories      = Dynamic.init([CategoryData]())
    var changes         = Dynamic.init([GenericData]())
    var categoryItems   = [NSCategory]()
    
    
    override init() {
        super.init()
        
        categoryLD.delegate = self
    }
    
    
    // MARK:- Functions
    
    
    func fetchData() {
        
        if Persistence.shared.isAppAlreadyLaunchedForFirstTime {
            categoryLD.fetchCategories()
            Persistence.shared.isAppAlreadyLaunchedForFirstTime = false
            
            Persistence.shared.refreshToken = Utility.getCurrentTimeStamp()
        } else {
            // fetch from core data
            self.categoryItems = NSCategory.getCategories()
            self.categories.value = CategoryData().fromNSManagedObject(categories: self.categoryItems)
            categoryLD.categories = self.categories.value
            
            print(" pending jobs are \(String(describing: JobFactory.queueManager?.jobCount()))")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
                // Code you want to be delayed
                categoryLD.fetchChanges()
            }
        }
    
    }
    
    func delete(index: Int) {
        
        let item = self.categoryItems.first { (entity) -> Bool in
            (entity.id == self.categories.value[index].id || entity.serverId == self.categories.value[index].id)
        }
        
        self.categories.value.removeAll(where: { (data) -> Bool in
            data.id == self.categories.value[index].id
        })
        
        if let object = item {
            object.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
        
        //for offline case add operations to queue
        
        let param = categoryLD.deleteParam(index: index)
        JobFactory.scheduleJob(param: param, jobType: CategoryDeletionJob.type, id: item?.id ?? "")
    }
    
    func Update(data: CategoryData) {
        
        let index = self.categories.value.firstIndex { (catData) -> Bool in
            catData.id == data.id
        }
        if let arrIndex = index {
            self.categories.value[arrIndex] = data
        }
    }
    
    func Delete(data: CategoryData) {
        
        let index = self.categories.value.firstIndex { (catData) -> Bool in
            catData.id == data.id
        }
        if let arrIndex = index {
            self.categories.value.remove(at: arrIndex)
        }
    }
    
}



// MARK:- Response Handling



extension CategoryListingVM {
    
    func handleFetch() {
        
        self.categories.value = categoryLD.categories
        
        PersistenceManager.sharedInstance.deleteAllRecords(entity: NSCategory.identifier)
        NSCategory.saveCategories(self.categories.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.categoryItems = NSCategory.categories//NSCategory.getCategories()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func handleDeletion() {
        // nothing to do list already deleted from core data
        
    }
    
    func handleUpdates() {
        self.changes.value = categoryLD.changesData
    }
    
}


// MARK:- Sockets Delegate


extension CategoryListingVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .read {
            self.handleFetch()
            
        } else if type == .delete {
            self.handleDeletion()
            
        } else if type == .changeStream {
            self.handleUpdates()
        }
    }
    
    func failure(type: responseTypes) {}
}
