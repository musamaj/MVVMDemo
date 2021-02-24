//
//  TaskDetailVM+CRUD.swift
//  TodoList
//
//  Created by Usama Jamil on 19/11/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import Foundation



// MARK:- Comment Api's


extension TaskDetailVM {
    
    func fetchComments() {
        
        self.commentItems   = CommentEntity.getComments(true, sortAscending: false, byTask: true)
        self.comments.value = CommentData().fromNSManagedObject(comments: self.commentItems)
        commentLD.comments  = self.comments.value
        
        if self.comments.value.isEmpty {
            commentLD.fetchComments()
        }
    }
    
    func comment(params: [String: AnyObject]) {
        
        let comment                            = CommentData()
        comment.id                             = UUID().uuidString
        comment.createdAt                      = Utility.getCurrentTimeStamp()
        comment.content                        = params[App.paramKeys.comment] as? String
        
        let userData                           = UserData()
        userData.id                            = Persistence.shared.currentUserID
        userData.name                          = Persistence.shared.currentUserUsername
        userData.email                         = Persistence.shared.currentUserEmail
        
        comment.userId                         = userData
        
        let item = CommentEntity.saveComment(comment)
        self.commentItems.append(item)
        self.commentData.value                 = comment
        
        var param = commentLD.createParam(params: params)
        param[App.paramKeys.fetchID] = self.commentData.value.id
        
        JobFactory.scheduleJob(param: param, jobType: CommentCreationJob.type, id: comment.id ?? "")
        //}
    }
    
    func deleteComment(commentId: String, index: Int) {
        
        self.comments.value.removeAll(where: { (data) -> Bool in
            data.id == commentId
        })
        let item = self.commentItems.first { (entity) -> Bool in
            (entity.id == commentId || entity.serverId == commentId)
        }
        
        //CommentEntity.deleteComment(item ?? CommentEntity())
        
        if let object = item {
            object.rowDeleted = true
            PersistenceManager.sharedInstance.mergeWithMainContext()
        }
        
        var param = commentLD.deleteParam(commentId: commentId)
        param[App.paramKeys.fetchID] = commentId
        
        JobFactory.scheduleJob(param: param, jobType: CommentDeletionJob.type, id: item?.id ?? "")
        //}
    }
    
}


extension TaskDetailVM {
    
    func handleCommentCreation() {
        CommentEntity.fetchId = self.commentData.value.id
        CommentEntity.updateComment(commentLD.commentData, true)
        self.fetchComments()
    }
    
    func handleCommentsFetch() {
        self.comments.value = commentLD.comments
        
        CommentEntity.deleteByPredicate(entity: CommentEntity.identifier)
        CommentEntity.saveComments(self.comments.value)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.commentItems = CommentEntity.getComments()
        }
    }
    
    func handleCommentDeletion() {
        // nothing here
    }
    
}