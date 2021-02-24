//
//  TaskListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 16/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import PopupKit


class TaskListingVC: BaseVC {

    
    // MARK:- Outlets & Properties
    
    
    @IBOutlet weak var tasksTableView   : UITableView!
    
    var tasksAdapter                    : TasksAdapter?
    var tasksVM                         = TasksListVM()
    var moreActions                     = MoreActions()
    @IBOutlet weak var btnShare         : UIButton!
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        shouldReturn = false
        self.viewConfiguration()
        
    }
    
    
    // MARK:- Overiding methods
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MembersListVM.shared.sharedListId = TasksListVM.selectedCategory?.id
        self.setDefaults(TasksListVM.selectedCategory?.name ?? App.navTitles.todo, rightStr: App.barItemTitles.edit)
        self.setNavigationBar(self)
        self.navColor(color: AppTheme.themeColor())
        
        tasksVM.fetchData()
        
        self.bindViews()
        
    }
    
    override func actRight() {
        
        let item = self.navigationItem.rightBarButtonItem
        
        if item?.title == App.barItemTitles.add {
            self.taskCreation()
        } else if item?.title == App.barItemTitles.done {
            self.endEditing()
        }
    }
    
    
    // MARK:- Functions
    
    
    func viewConfiguration() {
        
        taskLD.delegate = tasksVM
        self.moreActions = MoreActions.fromNib()
        self.tasksAdapter = TasksAdapter.init(tableView: self.tasksTableView, fetchedData: [""], viewModel: tasksVM)
        
    }
    
    func bindViews() {
        
        tasksVM.taskData.bind({ [weak self] (data) in
            self?.tasksAdapter?.reloadAdapter()
        })
        
        tasksVM.completedTasks.bind { [weak self] (data) in
            self?.tasksAdapter?.reloadAdapter()
        }
        
        tasksVM.uncompletedTasks.bind { [weak self] (data) in
            self?.tasksAdapter?.reloadAdapter()
        }
        
        tasksVM.showCompleted.bind { [weak self] (data) in
            self?.tasksAdapter?.reloadAdapter()
        }
    }
    
    func taskCreation() {
        if let cell = tasksTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? NewTaskCell, let title = cell.txtTitle.text {
            cell.txtTitle.text?.removeAll()
            tasksVM.create(taskName: title)
        }
    }
    
    func invite() {
        let invitePopup : InvitePopup = InvitePopup.fromNib()
        let view = PopupView.init(contentView: invitePopup)
        view.show()
        
        MembersListVM.shared.inviteEmail.bind { (data) in
            invitePopup.lblEmail.text?.removeAll()
            view.dismiss(animated: true)
        }
    }
    
    
    // MARK:- IBActions
    

    @IBAction func actShare(_ sender: Any) {
        //self.navigateToMembers()
        self.invite()
    }
    
    @IBAction func actMore(_ sender: Any) {
        let btnMore = (sender as? UIButton)
        btnMore?.isSelected = !(btnMore?.isSelected ?? false)
        
        Animations.toggleMenu(menuView: self.moreActions, controller: self, tabBarHeight: App.Constants.defaulttabbar, toggle: btnMore?.isSelected ?? false)
    }
    
}
