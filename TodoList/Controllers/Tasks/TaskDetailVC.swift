//
//  TaskCreationVC.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

struct taskConstants {
    
    static let descriptionDefaultHeight : CGFloat = 40
    static let descriptionExpandPadding : CGFloat = 20
    static let maxExpandConstant        : CGFloat = 120
    
    struct table {
        
        static let sections = 4
        
        static let cells = [NoteCell.self, AssigneeCell.self, AssignedCell.self, SubtaskCell.self, CommentDetailCell.self]
        
        static let rowHeights : [CGFloat] = [UITableView.automaticDimension, UITableView.automaticDimension, 80, UITableView.automaticDimension]
        static let sectionHeights : [CGFloat] = [CGFloat.leastNormalMagnitude, UITableView.automaticDimension, CGFloat.leastNormalMagnitude, CGFloat.leastNormalMagnitude]
    }
    
}


class TaskDetailVC: UIViewController {

    
    // MARK:- OUTLETS & PROPERTIES
    
    
    @IBOutlet weak var detailsTableView         : UITableView!
    @IBOutlet weak var txtComment               : UITextView!
    @IBOutlet weak var txtDescription           : UITextView!
    @IBOutlet weak var bottomContainerHeight    : NSLayoutConstraint!
    @IBOutlet weak var topBarHeight             : NSLayoutConstraint!
    @IBOutlet weak var btnSend                  : UIButton!
    
    
    var taskDetailAdapter : TaskDetailsAdapter?
    var taskDetailVM      = TaskDetailVM()
    
    
    // MARK:- LIFE CYCLE
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       self.viewConfig()
        
        taskDetailVM.fetchSubtasks()
        taskDetailVM.fetchComments()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarUIView?.backgroundColor = AppTheme.navBarthemeColor()
        hideNav()
        taskDetailAdapter?.reloadAdapter()
        
        self.bindViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarUIView?.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textViewDidChange(txtDescription)
    }
    
    
    // MARK:- FUNCTIONS
    
    
    func viewConfig() {
        
        txtDescription.delegate = self
        txtDescription.returnKeyType = .done
        txtComment.delegate = self
        
        subTaskLD.delegate = taskDetailVM
        commentLD.delegate = taskDetailVM
        
        hideNav()
        
        self.txtDescription.text = self.taskDetailVM.taskData.value.descriptionField
        taskDetailAdapter = TaskDetailsAdapter.init(tableView: detailsTableView, fetchedData: [], viewModel: taskDetailVM)
    }
    
    func bindViews() {
        
        taskDetailVM.taskData.bind { [weak self] (data) in
            self?.txtDescription.text = self?.taskDetailVM.taskData.value.descriptionField
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.subTasks.bind { [weak self] (data) in
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.subtaskData.bind { [weak self] (data) in
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.comments.bind { [weak self] (data) in
            self?.taskDetailAdapter?.reloadAdapter()
        }
        taskDetailVM.commentData.bind { [weak self] (data) in
            self?.btnSend.isUserInteractionEnabled = true
            self?.endEditing()
            self?.txtComment.text?.removeAll()
            self?.bottomContainerHeight.constant = taskConstants.descriptionDefaultHeight  + taskConstants.descriptionExpandPadding
            self?.taskDetailVM.comments.value.append(data)
            self?.taskDetailAdapter?.reloadAdapter()
        }
        
        //MembersListVM.shared.taskDetailVM = taskDetailVM
    }
    
    func param()-> [String: AnyObject] {
        return [App.paramKeys.desc      : txtDescription.text as AnyObject]
    }
    
    
    // MARK:- IBACTIONS
    
    
    @IBAction func actSend(_ sender: Any) {
        
        if !txtComment.text.isEmpty {
            btnSend.isUserInteractionEnabled = false
            taskDetailVM.comment(params: [App.paramKeys.comment : txtComment.text as AnyObject])
        }
    }
    
    @IBAction func actBack(_ sender: Any) {
        self.pop()
    }
    
}


extension TaskDetailVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let expandedHeight = textView.getExpandedHeight(taskConstants.maxExpandConstant)
        if textView == txtComment {
            bottomContainerHeight.constant = expandedHeight + taskConstants.descriptionExpandPadding
        } else {
            topBarHeight.constant = expandedHeight + taskConstants.descriptionExpandPadding
        }
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            if textView == txtDescription && txtDescription.isValid() {
                taskDetailVM.taskData.value.descriptionField = txtDescription.text
                taskDetailVM.updateTask(params: param())
            }
            return false
        }
        return true
    }
    
}
