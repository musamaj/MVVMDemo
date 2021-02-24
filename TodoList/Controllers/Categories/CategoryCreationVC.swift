//
//  CategoryCreationVC.swift
//  TodoList
//
//  Created by Usama Jamil on 10/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit
import PopupKit


class CategoryCreationVC: BaseVC {

    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var categorySections: UITableView!
    
    var sectionsAdapter : CategorySectionsAdapter?
    var categoryVM      = CategoryCreationVM()
    
    
    
    // MARK:- Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewConfiguration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bindViews()
        if let _ = categoryVM.categoryData.value.id {
            categoryVM.fetchUsers()
        }
    }
    
    func viewConfiguration() {
        
        inviteLD.delegate   = categoryVM
        categoryLD.delegate = categoryVM
        
        var rightBarTitle = createStr
        var navTitle      = App.navTitles.listCreation
        
        if let _ = categoryVM.categoryData.value.name {
            rightBarTitle = updateStr
            navTitle      = App.navTitles.editList
        }
        
        self.setDefaults(navTitle, rightStr: rightBarTitle)
        self.setNavigationBar(self)
        
        self.sectionsAdapter = CategorySectionsAdapter.init(tableView: self.categorySections, viewModel: self.categoryVM, controller: self)
        
    }
    
    func bindViews() {
        categoryVM.categoryData.bind{ [weak self] (data) in
            self?.rightButton.isEnabled = true
            self?.pop()
        }
        
        categoryVM.categoryUsers.bind { [weak self] (data) in
            self?.sectionsAdapter?.reloadAdapter()
        }
        
    }
    
    func inviteAndBind() {
        
        let invitePopup : InvitePopup = InvitePopup.fromNib()
        let view = PopupView.init(contentView: invitePopup)
        view.show()
        
        MembersListVM.shared.inviteEmail.bind { (data) in
            invitePopup.lblEmail.text?.removeAll()
            self.categoryVM.fetchUsers()
            view.dismiss(animated: true)
        }
    }
    
    
    // MARK:- Functions
    
    
    override func actRight() {
        
        if let cell = categorySections.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TitleCell, let title = cell.txtTitle.text {
            if cell.txtTitle.isValid() {
                self.rightButton.isEnabled = false
                categoryVM.create(categoryName: title)
            }
        }
    }
    
}
