//
//  TasksAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 17/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class TasksAdapter: NSObject {
    
    weak var tasksTableView     : UITableView!
    var tasksVM                 = TasksListVM()
    var extraRow                = [1,0]
    
    
    init(tableView: UITableView, fetchedData:[String], viewModel: TasksListVM) {
        super.init()
        
        tasksVM = viewModel
        
        tableView.registerNib(from: NewTaskCell.self)
        tableView.registerNib(from: TaskCell.self)
        tableView.registerNib(from: CompleteTaskHeader.self)
        
        tasksTableView = tableView
        //tasksTableView.backgroundColor = .white
        
        tasksTableView.keyboardDismissMode = .onDrag
        tasksTableView.estimatedRowHeight = App.tableCons.estRowHeight
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.tableFooterView = UIView(frame: .zero)
        tasksTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tasksTableView.frame.size.width, height: 0.01))
        
        tasksTableView.reloadData()
    }
    
    public func reloadAdapter() {
        self.tasksTableView.reloadData()
    }
}


extension TasksAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = tasksVM.completedTasks.value.count > 0 ? 2 : 1
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1 && !(tasksVM.showCompleted.value) {
            return 0
        }
        
        let rows = section == 0 ? (tasksVM.uncompletedTasks.value.count) + extraRow[section] : tasksVM.completedTasks.value.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CompleteTaskHeader.identifier) as? CompleteTaskHeader {
                headerView.populateData(viewModel: tasksVM)
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 {
            return App.tableCons.headerHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            Utility.deleteCallBack = {
                let taskData = indexPath.section == 0 ? self.tasksVM.uncompletedTasks.value[indexPath.row-1] : self.tasksVM.completedTasks.value[indexPath.row]
                self.tasksVM.delete(id: taskData.id ?? "")
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            guard let cell : NewTaskCell = tableView.dequeue(cell: NewTaskCell.self) else { return UITableViewCell() }
            cell.contentView.setRounded(cornerRadius: App.Constants.defaultRadius)
            return cell
            
        } else {
            guard let cell : TaskCell = tableView.dequeue(cell: TaskCell.self) else { return UITableViewCell() }
            let taskData = indexPath.section == 0 ? tasksVM.uncompletedTasks.value[indexPath.row-1] : tasksVM.completedTasks.value[indexPath.row]
            cell.populateData(viewModel: tasksVM, data: taskData)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0 {
            return App.tableCons.taskCell
        }
        return App.tableCons.cellHeight
    }
    
}

extension TasksAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TaskDetailVM.delegate = tasksVM
        
        if indexPath.row > 0 || indexPath.section == 1 {
            let taskData = indexPath.section == 0 ? tasksVM.uncompletedTasks.value[indexPath.row-1] : tasksVM.completedTasks.value[indexPath.row]
            let item = tasksVM.taskItems.first { (entity) -> Bool in
                (entity.id == taskData.id || entity.serverId == taskData.id)
            }
            TaskEntity.selectedTask = item
            UIApplication.topViewController()?.navigateToTaskDetail(task: taskData, category: TasksListVM.selectedCategory ?? CategoryData())
        }
    }
}
