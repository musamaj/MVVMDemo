//
//  CategoryListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 04/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class CategoryListingVC: UIViewController {

    
    // MARK:- IBOutlets
    
    
    @IBOutlet weak var btnAdd           : UIButton!
    @IBOutlet weak var tblCategories    : UITableView!
    
    var categoriesAdapter               : CategoriesAdapter?
    var categoryVM                      = CategoryListingVM()
    
    
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
        
        categoryLD.delegate = categoryVM
        self.bindViews()
        self.bindChanges()
        
        if Persistence.shared.isAppAlreadyLaunchedForFirstTime {
            SocketIOManager.sharedInstance.connected.bind { (isConnected) in
                if isConnected {
                    self.categoryVM.fetchData()
                }
            }
            
        } else {
            self.categoryVM.fetchData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Utility.navbarPopGestureDisable(controller: self)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    // MARK:- Functions
    
    
    func viewConfiguration() {
        
        self.setCustomNav()
        
        self.btnAdd.setRounded()
        self.categoriesAdapter = CategoriesAdapter.init(tableView: self.tblCategories, fetchedData: [], controller: self)

    }
    
    func bindViews() {
        categoryVM.categories.bind { [weak self] (data) in
            self?.categoriesAdapter?.reloadAdapter()
        }
    }
    
    func bindChanges() {
        categoryVM.changes.bind { (data) in
            for change in data {
                ChangesManager.shared.handleChange(data: change)
            }
        }
    }
    
    
    // MARK:- IBActions
    
    
    @IBAction func actAdd(_ sender: Any) {
        self.navigateToCategoryCreation()
    }

}
