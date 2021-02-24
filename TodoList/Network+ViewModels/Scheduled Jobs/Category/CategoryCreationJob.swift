//
//  CategoryCreationJob.swift
//  TodoList
//
//  Created by Usama Jamil on 06/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation
import SwiftQueue

// A job to send a tweet
class CategoryCreationJob: Job {
    
    // Type to know which Job to return in job creator
    static let type = "CategoryCreationJob"
    // Param
    private let tweet: [String: Any]
    
    let categoryLD = CategoryLoader()
    var result     : JobResult?
    
    required init(params: [String: Any]) {
        // Receive params from JobBuilder.with()
        self.tweet = params
    }
    
    func onRun(callback: JobResult) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + App.Constants.jobDelay) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            NSCategory.fetchId = self.tweet[App.paramKeys.fetchID] as? String
            self.categoryLD.categoryData.fetchId = self.tweet[App.paramKeys.fetchID] as? String
            
            self.categoryLD.delegate = self
            self.categoryLD.createCategory(param: self.tweet)
            self.result = callback
        }
        
    }
    
    func onRetry(error: Error) -> RetryConstraint {
        // Check if error is non fatal
        return RetryConstraint.retry(delay: 5) // immediate retry
    }
    
    func onRemove(result: JobCompletion) {
        // This job will never run anymore
        switch result {
        case .success:
            // Job success
            DispatchQueue.main.async {
                NSCategory.updateByPredicate(self.categoryLD.categoryData)
            }
            break
            
        case .fail(let error):
            // Job fail
            print(error.localizedDescription)
            break
            
        }
    }
    
    func onSuccess() {
        
    }
}


// MARK:- Sockets Delegate


extension CategoryCreationJob: NetworkDelegate {
    
    func populateData(type: responseTypes) {
        
        if type == .create {
            //self.handleCreation()
            self.result?.done(.success)
        }
    }
    
    func failure(type: responseTypes) {
        self.result?.done(.fail(NSError.init(errorMessage: errorStr)))
    }
}
