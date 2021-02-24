//
//  MembersListVC.swift
//  TodoList
//
//  Created by Usama Jamil on 12/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class MembersListVC: BaseVC {
    
    
    @IBOutlet weak var searchBar        : UISearchBar!
    @IBOutlet weak var membersTableView : UITableView!
    
    var membersAdapter                  : MembersAdapter?
    var taskDetailVM                    = TaskDetailVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.viewConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bindViews()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func actRight() {
        
        if let index = MembersListVM.shared.selectedUserIndex {
            
            let userData = UserData()
            
            userData.id    = MembersListVM.shared.categoryUsers.value[index].id
            userData.name  = MembersListVM.shared.categoryUsers.value[index].name
            userData.email = MembersListVM.shared.categoryUsers.value[index].email
            
            taskDetailVM.taskData.value.assigneeId = userData
            
            taskDetailVM.updateTask(params: param(index: index))
            MembersListVM.shared.selectedUserIndex = nil
            self.pop()
        } else {
            self.pop()
        }
    }
    
    func param(index: Int)-> [String: AnyObject] {
        return [App.paramKeys.assigneeId      : MembersListVM.shared.categoryUsers.value[index].id as AnyObject]
    }
    
    func viewConfiguration() {
        
        searchBar.delegate = self
        MembersListVM.shared.categoryUsers.value.removeAll()
        self.setDefaults(App.navTitles.membersList, rightStr: App.barItemTitles.done)
        self.setNavigationBar(self)
        
        self.membersAdapter = MembersAdapter.init(tableView: self.membersTableView, fetchedData: [""], controller: self)
        
        MembersListVM.shared.fetchUsers()
    }
    
    func bindViews() {
        
        MembersListVM.shared.categoryUsers.bind { (users) in
            self.membersAdapter?.reloadAdapter()
        }
    }
    
}


extension MembersListVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
