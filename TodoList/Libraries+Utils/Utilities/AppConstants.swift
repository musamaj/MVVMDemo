//
//  AppConstants.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 06/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//


import UIKit
import SwiftyUserDefaults



struct App {
    
    struct SDKKeys {
        static let googleId = "716644032646-781e09lq38fjo7q25ju7fbv05rtt1j07.apps.googleusercontent.com".localized()
    }
    
    struct navTitles {
        static let todo         = "Tasks".localized()
        static let listCreation = "New List".localized()
        static let editList     = "Edit List".localized()
        static let foldersList  = "Folders".localized()
        static let membersList  = "Share".localized()
        static let profile      = "Account Details".localized()
        static let taskDetail   = "Task Details".localized()
        static let notes        = "Notes".localized()
    }
    
    struct Constants {
        static let cellPadding   : CGFloat = 1
        static let fieldPadding  : CGFloat = 8
        static let defaultRadius : CGFloat = 8
        static let defaulttabbar : CGFloat = 60
        static let jobDelay      : Double = 0.0
        static let jobDelay1     : Double = 1.0
    }
    
    struct tableCons {
        static let defaultHeight : CGFloat = 50
        static let cellHeight   : CGFloat  = 60
        static let headerHeight : CGFloat = 60
        static let taskCell     : CGFloat  = 80
        static let estHeaderHeight : CGFloat = 50
        static let estRowHeight : CGFloat = 50

    }
    
    struct Validations {
        
        // validations strings
    
        static let requiredStr                         = "Please enter required fields".localized()
        static let usernameStr                         = "Please enter username".localized()
        static let firstNameStr                        = "Please enter first name".localized()
        static let lastNameStr                         = "Please enter last name".localized()
        static let emailStr                            = "Please enter email".localized()
        static let passwordStr                         = "Please enter password".localized()
        static let compareStr                          = "Passwords mismatch".localized()
        static let emailValidationStr                  = "Please enter valid email".localized()
        static let urlValidationStr                    = "Please enter valid url".localized()
        static let signInStr                           = "Have an account already? Sign In".localized()
        static let forgotStr                           = "Password reset details sent to your email".localized()
        static let listShared                          = "List Already shared".localized()
        static let noUsers                             = "Please invite users to assign task".localized()
    }
    
    struct dateFormats {
        /**
         * Date Patterns
         */
        let datePattern_Display_Time            = "HH:mm:ss"
        let datePattern_Display_TimeAM          = "hh:mm a"
        let datePattern_Display_DateAndTime     = "MMM dd, yyyy - hh:mm a"
        let datePattern_Display_Date            = "MM-dd-YYYY"
        let datePattern_Server                  = "MM-dd-yyyy"
        let pastDelivery_datePattern            = "dd-MM-yyyy"
        let pastDelivery_weekdatePattern        = "EEEE (dd-LLL-yyyy)"
        let datePattern_CompletedJob            = "yyyy-MM-dd hh:mm:ss"
    }
    
    struct paramKeys {
        static let name                         = "name".localized()
        static let done                         = "done".localized()
        static let desc                         = "description".localized()
        static let note                         = "note".localized()
        static let assigneeId                   = "assigneeId".localized()
        static let limit                        = "limit".localized()
        static let comment                      = "content".localized()
        static let inviteEmail                  = "invitee_email".localized()
        static let listId                       = "listId".localized()
        static let list_id                      = "list_id".localized()
        static let taskId                       = "taskId".localized()
        static let subtaskId                    = "subtaskId".localized()
        static let subtask                      = "subtask".localized()
        static let commentStr                   = "comment".localized()
        static let commentId                    = "commentId".localized()
        static let listName                     = "listName".localized()
        static let userId                       = "userId".localized()
        static let Id                           = "id".localized()
        static let msg                          = "message".localized()
        static let error                        = "error".localized()
        static let data                         = "data".localized()
        static let body                         = "body".localized()
        static let auth                         = "auth_token".localized()
        static let fetchID                      = "fetchID".localized()
        static let timestamp                    = "timestamp".localized()
    }
    
    struct barItemTitles {
        static let edit                         = "".localized()
        static let done                         = "Done".localized()
        static let cancel                       = "Cancel".localized()
        static let add                          = "Add".localized()
        static let save                         = "Save".localized()
        static let owner                        = "Owner".localized()
        static let pending                      = "Pending".localized()
    }
    
    struct toggleKeys {
        static let show                         = "SHOW COMPLETED TO-DOS"
        static let hide                         = "HIDE COMPLETED TO-DOS"
    }
    
    struct  messages {
        static let invite                       = "Invitation Sent"
        static let syncPending                  = "Data syncing is in progress"
    }
    
    struct Events {
        
        // Category CRUD
        static let createList                       = "createList"
        static let updateList                       = "updateList"
        static let getLists                         = "getUserLists"
        static let deleteList                       = "deleteList"
        
        static let getListUsers                     = "getListUsers"
        static let unshareAList                     = "unshareAList"
        
        
        // Task CRUD
        static let createTask                       = "createTask"
        static let getTasks                         = "getListTasks"
        static let deleteTask                       = "deleteTask"
        static let updateTask                       = "updateTask"
        
        
        // Comments CRUD
        static let createComment                       = "createComment"
        static let getComments                         = "getTaskComments"
        static let deleteComment                       = "deleteComment"
        
        
        // Subtasks CRUD
        static let createSubtask                        = "createSubtask"
        static let getSubtasks                          = "getSubtasks"
        static let updateSubtask                        = "updateSubtask"
        static let deleteSubtask                        = "deleteSubtask"
        
        
        static let shareAList                           = "shareAList"
        
        
        // Category Listeners
        static let listDeleted                        = "listDeleted"
        static let listUpdated                        = "listUpdated"
        static let listShared                         = "listShared"
        static let listUnshared                       = "listUnshared"
        static let joinAList                          = "joinAList"
        
        
        // Task Listeners
        static let taskDeleted                        = "taskDeleted"
        static let taskUpdated                        = "taskUpdated"
        static let taskCreated                        = "taskCreated"
        
        
        // SubTask Listeners
        static let subTaskCreated                     = "subTaskCreated"
        static let subTaskDeleted                     = "subTaskDeleted"
        static let subTaskUpdated                     = "subTaskUpdated"
        
        
        // Comment Listeners
        static let commentCreated                     = "commentCreated"
        static let commentDeleted                     = "commentDeleted"
        static let commentUpdated                     = "commentUpdated"
        
    }
    
}

/**
 * General Class singleton constants
 */

let userDefaults: UserDefaults = UserDefaults.standard
let notifCenter: NotificationCenter = NotificationCenter.default
let application = UIApplication.shared
let appDelegate = application.delegate as! AppDelegate
let appUtility = AppUtility.sharedInstance
let persistence = Persistence.shared



var baseUrl: String {
    
    var baseUrl = ""

    switch appMode {
        case .test:
            baseUrl = "https://todo-api-s63.herokuapp.com"
        case .production:
            baseUrl = "https://e6b5ec41.ngrok.io"
    }
    
    return baseUrl
}

var appBundle: String {
    
    var baseUrl = ""
    
    switch appMode {
    case .test:
        baseUrl = "com.square63.TodoSTG"
    case .production:
        baseUrl = ""
    }
    
    return baseUrl
}



struct CategoryStrs {
    static let create    = "Create List".localized()
    static let addMember = "Add People".localized()
    static let categories  = [0: ["Veggies", "Random"],
                              1: ["Important", "Maintenance"],
                              2: ["Notes", "Domestic", "Starred"],
                              3 : ["Create List"]]
    static let arrCategories = ["Veggies", "Random", "Starred", "Maintenance","Important", "Maintenance"]
    static let sections  = ["LIST MEMBERS", "FOLDER"]
    static var foldersArr = ["Grocery", "Miscellaneous"]
    static let todoStr      = "Add a to-do...".localized()
    
    struct tableCons {
        static let defaultHeight : CGFloat = 50
        static let cellHeight   : CGFloat  = 60
        static let headerHeight : CGFloat = 60
    }
    
}


let contentTypeKey          = "Content-Type"
let jsonContentType         = "application/json"
let multipartContentType    = "multipart/form-data"
let urlEncodedContent       = "application/x-www-form-urlencoded"
let dataKey                 = "data"
let authHeaderKey           = "Authorization"
let authEmailKey            = "X-USER-EMAIL"
let perPageItems            = 10


/**
 * General constants
 */


let errorStr                            = "Something went wrong"
let authStr                             = "You're not authorized to perform this action"
let errorKey                            = "Error"
let successKey                          = "Success"
let defaultStr                          = "Default"
let refreshStr                          = "Pull to refresh"
let signInSubStr                        = "Sign In"
let cancelStr                           = "Cancel"
let createStr                           = "Create"
let updateStr                           = "Update"
let editStr                             = "Edit"
let backStr                             = "Back"
let addStr                              = "Add"
let youStr                              = "You"




/**
 * App keys
 */
let keyAuthToken                        = "appToken"
let keyFbUserInfo                       = "fbInfo"
let keyAmazonUserInfo                   = "amazonInfo"
let keyUserInfo                         = "userInfo"
let keyCurrentUserEmail                 = "currentUserEmail"
let keyIntroViewSeen                    = "isIntroViewSeen"
let keyAppUser                          = "appUser"
let keyExistingJob                      = "existingJob"


// Button titles
let buttonOK             = "OK"
let buttonCancel         = "Cancel"



// Persistence Keys

extension DefaultsKeys
{
    static let isAppAlreadyLaunchedForFirstTime = DefaultsKey<Bool?>("isAppAlreadyLaunchedForFirstTime")
    static let isUserAlreadyLoggedIn            = DefaultsKey<Bool?>("isUserAlreadyLoggedIn")
    static let isSignedUp                       = DefaultsKey<Bool?>("isSignedUp")
    static let isSocailLoggedIn                 = DefaultsKey<Bool?>("isSocialLoggedIn")
    
    static let currentUserID                    = DefaultsKey<String?>("currentUserID")
    static let currentUserUrlHash               = DefaultsKey<String?>("currentUserUrlHash")
    static let currentUserFirstName             = DefaultsKey<String?>("currentUserFirstName")
    static let currentUserLastName              = DefaultsKey<String?>("currentUserLastName")
    static let currentUserEmail                 = DefaultsKey<String?>("currentUserEmail")
    static let currentUserUsername              = DefaultsKey<String?>("currentUserUsername")
    static let currentUserLocation              = DefaultsKey<String?>("currentUserLocation")
    static let currentUserBio                   = DefaultsKey<String?>("currentUserBio")
    static let lastUserEmail                    = DefaultsKey<String?>("lastUserEmail")
    static let lastUserPassword                 = DefaultsKey<String?>("lastUserPassword")
    static let currentIsVerified                = DefaultsKey<Bool?>("currentIsVerified")
    static let accessToken                      = DefaultsKey<String?>("accessToken")
    static let deviceID                         = DefaultsKey<String?>("deviceID")
    static let refreshToken                     = DefaultsKey<String?>("refreshToken")
    
}



