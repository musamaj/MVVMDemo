//
//  NetworkManager.swift
//  FanTazTech
//
//  Created by Muhammad Azher on 12/01/2018.
//  Copyright © 2018 Expertinsol. All rights reserved.
//

import Foundation
import Alamofire


// Create an Enum named as Endpoint to add app specific end points. Conform it with Directable to make directable urls.

enum Endpoint: Directable {
    
    case

    register,
    login,
    forgot,
    invite,
    uploadImg,
    changeStreams(String),
    categories,
    sharedCategories,
    task(String),
    taskUpdate(String, String),
    subtasks(String),
    updatesubtask(String, String),
    comments(String),
    assign(String,String),
    completeTask(String,String),
    completeSubTask(String,String),
    logout,
    deleteMealPlanWithMealId(String)
    
    
    func directableURLString() -> String {
        
        var servicePath = ""
        
        switch (self) {

        // auth urls
            
        case .register:
            servicePath = "users"
        case .login:
            servicePath = "users/login"
        case .forgot:
            servicePath = "users/forget_password"
        case .changeStreams(let timeStamp):
            servicePath = "users/me/change_streams?timestamp=\(timeStamp)"
        case .invite:
            servicePath = "invitations"
        case .uploadImg:
            servicePath = "users/me/image"
        case .categories:
            servicePath = "lists"
        case .sharedCategories:
            servicePath = "lists/shared"
            
        // tasks urls
            
        case .task(let categoryId):
            servicePath = "lists/\(categoryId)/tasks"
        case .taskUpdate(let categoryId, let taskId):
            servicePath = "lists/\(categoryId)/tasks/\(taskId)"
        case .subtasks(let taskId):
            servicePath = "tasks/\(taskId)/subtasks"
        case .updatesubtask(let taskId, let subtaskId):
            servicePath = "tasks/\(taskId)/subtasks/\(subtaskId)"
        case .completeSubTask(let subtaskId, let taskId):
            servicePath = "tasks/\(taskId)/subtasks/\(subtaskId)/complete"
            
        case .comments(let taskId):
            servicePath = "tasks/\(taskId)/comments"
        case .assign(let categoryId, let taskId):
            servicePath = "lists/\(categoryId)/tasks/\(taskId)/assign"
        case .completeTask(let categoryId, let taskId):
            servicePath = "lists/\(categoryId)/tasks/\(taskId)/complete"
            
        case .logout:
            servicePath = ""
            
            
        case .deleteMealPlanWithMealId(let mealPlanId):
            servicePath = "meal_plans/" + mealPlanId
            
            
        // case category urls
            
            
        }
        
        return baseUrl + "/" + servicePath
    }
}

/// Service Manager of application
///
/// - Usage:
///     - Must implement the *authorizationHeadersIf* method to send headers to your server
///     - Must implement the *handleServerError* method to validate the error from your server


class NetworkManager: Routable {
    
    func    authorizationHeadersIf(_ authorized: Bool) -> [String : String]? {
        
        guard let accessToken = Persistence.shared.accessToken else {return [:]}
        let headers: HTTPHeaders = [
            authHeaderKey: accessToken
        ]
        
        
        //if authorized {
            //headers["Authorization"] = "bearer \(String(describing: accessToken))"
                //QL1("bearer \(String(describing: token))")
        //}
        
        //headers["Accept"] = "application/json"
//        headers["API_KEY"] = "132547"
//        headers["auth_token"] = AppUtility.sharedInstance.appAuthToken

//        headers["Content-Type"] = "application/json"
        //        headers!["platform"] = "ios"
        //        headers!["app-version"] = "1.4.2"
        
        return headers
    }
    
    
    func handleServerError(_ result: DataResponse<JSONTopModal>, failure: FailureErrorBlock!) -> Bool {
        
        
        let resultValue = result.value!
        if resultValue.message == "Unauthorized access" {

//            appUtility.handleTokenExpiry(messageTokenExpired)
            AppUtility.sharedInstance.logout()
            
            return true
        }
        
        return false
    }
}

// MARK:- Server Specific Errors

extension NetworkManager {

}
