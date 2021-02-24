//
//  CategoryCreationVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import CoreData
import ObjectMapper
import SwiftQueue


class CategoryCreationVM: NSObject {

    
    // MARK:- Properties
    
    static var pendingTaskId : Double?
    
    var categoryData    = Dynamic.init(CategoryData())
    var categoryUsers   = Dynamic.init([RegisterUser]())
    
    var userItems       = [SharedUsersEntity]()
    
    
    override init() {
       // super.init()
        
    }
    
    // MARK:- Functions
    
    
    func createParam(_ categoryName: String)-> [String: Any] {
        return [   App.paramKeys.listName     : categoryName,
                   App.paramKeys.userId       : Persistence.shared.currentUserID]
    }
    
    func updateParam(_ categoryName: String)-> [String: Any] {
        let body = [ App.paramKeys.name : categoryName
                   ]
        return [App.paramKeys.body: body,
                App.paramKeys.listId : self.categoryData.value.id as Any,
                App.paramKeys.userId : Persistence.shared.currentUserID
        ]
    }
    
    func fetchUsers() {
        
        // local implementation is here
        
        self.userItems              = SharedUsersEntity.getUsers(true, sortAscending: false, byCategory: true)
        self.categoryUsers.value    = RegisterUser().fromNSManagedObject(users: self.userItems)
        inviteLD.categoryUsers      = self.categoryUsers.value
        
        if self.categoryUsers.value.isEmpty {
            inviteLD.fetchUsers()
        }
    }
    
    func unshare(userID: String) {
        
        self.categoryUsers.value.removeAll(where: { (data) -> Bool in
            data.id == userID
        })
        let item = self.userItems.first { (entity) -> Bool in
            entity.id == userID || entity.serverId == userID
        }
        
        if let object = item {
            object.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
        
        var param = inviteLD.unshareParam(userId: userID)
        param[App.paramKeys.fetchID] = userID
        
        JobFactory.scheduleJob(param: param, jobType: UnshareJob.type, id: item?.id ?? "")
    }
    
    func create(categoryName: String) {
        
        categoryData.value.synced = false
        
        if let _ = self.categoryData.value.name {
            categoryData.value.name   = categoryName
            categoryData.value.updatedAt = Utility.getCurrentTimeStamp()
            NSCategory.updateCategory(categoryData.value, false)
            TasksListVM.selectedCategory = categoryData.value
            
        } else {
            categoryData.value.id     = UUID().uuidString
            categoryData.value.createdAt = Utility.getCurrentTimeStamp()
            categoryData.value.name   = categoryName
            NSCategory.saveCategory(categoryData.value)
        }
        
        self.onlineCalls(categoryName: categoryName)
        
        // set value to pop
        self.categoryData.value = categoryData.value
    }
    
    func onlineCalls(categoryName: String) {
        
        //for offline case add operations to queue
        
        if let _ = self.categoryData.value.updatedAt {
            NSCategory.fetchId = self.categoryData.value.id
            var param = self.updateParam(categoryData.value.name ?? "")
            param[App.paramKeys.fetchID] = self.categoryData.value.id
            
            JobFactory.scheduleJob(param: param, jobType: CategoryUpdateJob.type, id: self.categoryData.value.id ?? "")
            
        } else {
            NSCategory.fetchId = self.categoryData.value.id
            var param = self.createParam(categoryData.value.name ?? "")
            param[App.paramKeys.fetchID] = self.categoryData.value.id
            
            JobFactory.scheduleJob(param: param, jobType: CategoryCreationJob.type, id: self.categoryData.value.id ?? "")
        }
    }
    
}



// MARK:- Socket Events



extension CategoryCreationVM {
    
    func handleCreation() {
        NSCategory.fetchId = self.categoryData.value.id
        NSCategory.updateByPredicate(categoryLD.categoryData)
        
        //SocketIOManager.sharedInstance.connected.value = true
        let vc = UIApplication.topViewController() as? CategoryListingVC
        vc?.categoryVM.fetchData()
    }
    
    func handleUpdate() {
        NSCategory.updateCategory(categoryLD.categoryData)
        TasksListVM.selectedCategory = categoryLD.categoryData
    }
    
    func handleUsers() {
        //self.categoryUsers.value = inviteLD.categoryUsers
        
        // local implementation is here
        
        self.categoryUsers.value = inviteLD.categoryUsers
        
        SharedUsersEntity.deleteByPredicate(entity: SharedUsersEntity.identifier)
        SharedUsersEntity.saveUsers(self.categoryUsers.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.userItems    = SharedUsersEntity.getUsers()
        }
    }
    
}


// MARK:- Sockets Delegate


extension CategoryCreationVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .create {
            self.handleCreation()
            
        } else if type == .update {
            self.handleUpdate()
            
        } else if type == .users {
            self.handleUsers()
        }
    }
    
    func failure(type: responseTypes) {}
}
