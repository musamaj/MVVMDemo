//
//  TaskDetailsAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class TaskDetailsAdapter: NSObject {
    
    
    weak var detailsTableView     : UITableView!
    var taskDetailVM              = TaskDetailVM()
    
    
    init(tableView: UITableView, fetchedData:[String], viewModel: TaskDetailVM) {
        super.init()
        
        taskDetailVM = viewModel
        
        tableView.registerNibs(from: taskConstants.table.cells)
        tableView.registerNib(from: SubtaskHeader.self)
        
        detailsTableView = tableView
        detailsTableView.backgroundColor = AppTheme.lightGrayBG()
        detailsTableView.keyboardDismissMode = .onDrag
        
        detailsTableView.configure(self)
    }
    
    public func reloadAdapter() {
        self.detailsTableView.reloadData()
    }
}

extension TaskDetailsAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskConstants.table.sections
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 1 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SubtaskHeader.identifier) as? SubtaskHeader {
                headerView.taskDetailVM = taskDetailVM
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return taskConstants.table.sectionHeights[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 3 {
            return taskDetailVM.comments.value.count
        }
        if section == 1 {
            return taskDetailVM.subTasks.value.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.section == 3 && taskDetailVM.comments.value[indexPath.row].userId?.id == Persistence.shared.currentUserID) || indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            Utility.deleteCallBack = {
                
                if indexPath.section == 1 {
                    self.taskDetailVM.deleteSubtask(subtaskId: self.taskDetailVM.subTasks.value[indexPath.row].id ?? "", index: indexPath.row)
                    
                } else if indexPath.section == 3 {
                    if self.taskDetailVM.comments.value[indexPath.row].userId?.id == Persistence.shared.currentUserID {
                        self.taskDetailVM.deleteComment(commentId: self.taskDetailVM.comments.value[indexPath.row].id ?? "", index: indexPath.row)
                    } else {
                        Utility.showSnackBar(msg: authStr, icon: nil)
                    }
                }
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if let _ = taskDetailVM.taskData.value.assigneeId?.id {
                guard let cell : AssignedCell = tableView.dequeue(cell: AssignedCell.self) else { return UITableViewCell() }
                cell.populate(viewModel: taskDetailVM)
                return cell
                
            } else {
                guard let cell : AssigneeCell = tableView.dequeue(cell: AssigneeCell.self) else { return UITableViewCell() }
                return cell
            }
            
        } else if indexPath.section == 1 {
            guard let cell : SubtaskCell = tableView.dequeue(cell: SubtaskCell.self) else { return UITableViewCell() }
            cell.populateData(viewModel: taskDetailVM, index: indexPath.row)
            return cell
            
        } else if indexPath.section == 2 {
            guard let cell : NoteCell = tableView.dequeue(cell: NoteCell.self) else { return UITableViewCell() }
            cell.populateData(viewModel: taskDetailVM)
            return cell
            
        } else {
            guard let cell : CommentDetailCell = tableView.dequeue(cell: CommentDetailCell.self) else { return UITableViewCell() }
            cell.populateData(comment: taskDetailVM.comments.value[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return taskConstants.table.rowHeights[indexPath.section]
    }
    
}

extension TaskDetailsAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            UIApplication.topViewController()?.navigateToMembers(viewModel: taskDetailVM)
        }
        
        if indexPath.section == 2 {
            UIApplication.topViewController()?.navigateToNotes(viewModel: taskDetailVM)
        }
    }
}
