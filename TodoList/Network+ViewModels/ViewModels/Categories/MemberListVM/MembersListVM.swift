//
//  MembersListVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import ObjectMapper
import PopupKit


class MembersListVM: NSObject {

    
    static let shared   = MembersListVM()
    //var taskDetailVM    = TaskDetailVM()
    
    var categoryUsers   = Dynamic.init([RegisterUser]())
    var users           = [RegisterUser]()
    var sharedListId    : String?
    var selectedUserIndex    : Int?
    
    var inviteEmail     = Dynamic.init(String())
    
    
    // MARK:- Network Calling
    
    
    func params(email: String) -> [String: AnyObject] {
        return [App.paramKeys.listId       : (sharedListId ?? "") as AnyObject,
                App.paramKeys.inviteEmail   : email as AnyObject]
    }
    
}



extension MembersListVM {
    
    func invite(email: String) {
        
        let userData                        = RegisterUser()
        userData.id                         = UUID().uuidString
        userData.createdAt                  = Utility.getCurrentTimeStamp()
        userData.email                      = email
        
        let _ = SharedUsersEntity.addUser(userData)
        
        var params                          = MembersListVM.shared.params(email: email)
        params[App.paramKeys.fetchID]       = userData.id as AnyObject
        
        JobFactory.scheduleJob(param: params, jobType: ShareJob.type, id: userData.id ?? "")
        
        self.inviteEmail.value              = email
        
    }
    
    func fetchUsers() {
        
        self.users.removeAll()
        let param = [App.paramKeys.listId : self.sharedListId]
        
        SocketIOManager.sharedInstance.socket.emitWithAck(App.Events.getListUsers, param).timingOut(after: 0) {data in
            
            if data.count > 0 {
                if let response = data[0] as? [String: Any] {
                    guard let data = Mapper<RegisterUser>().mapArray(JSONObject: response[App.paramKeys.data]) else {
                        //Utility.showSnackBar(msg: response[App.paramKeys.msg] as? String ?? errorStr, icon: nil)
                        return
                    }
                    
                    if data.count == 0 {
                        //Utility.showSnackBar(msg: App.Validations.noUsers, icon: nil)
                    }
                    
                    self.users = data
                    self.setData()
                }
            }
        }
        
        if AppDelegate().reachability.connection == .none || self.users.count == 0 {
            self.setData()
        }
        
    }
    
    func setData() {
        let userData   = RegisterUser()
        userData.id    = TasksListVM.selectedCategory?.owner?.id
        userData.name  = TasksListVM.selectedCategory?.owner?.name
        userData.email = TasksListVM.selectedCategory?.owner?.email
        
        if let _ = userData.id {
            self.users.append(userData)
        }
        
        if AppDelegate().reachability.connection == .none || self.users.count == 0 {
            let currentUser = RegisterUser()
            if Persistence.shared.currentUserID != userData.id {
                currentUser.id  = Persistence.shared.currentUserID
                currentUser.name = Persistence.shared.currentUserUsername
                currentUser.email = Persistence.shared.currentUserEmail
                
                self.users.append(currentUser)
            }
        }
        
        self.categoryUsers.value = self.users
    }
    
}




// MARK:- Sockets Delegate


extension MembersListVM: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .users {
            //self.handleUsers()
        }
    }
    
    func failure(type: responseTypes) {}
}
