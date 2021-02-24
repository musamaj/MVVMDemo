//
//  FoldersListingVC.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class FoldersListingVC: BaseVC {

    @IBOutlet weak var foldersTableView: UITableView!
    
    var foldersAdapter : FoldersAdapter?
    var foldersVM      : FoldersListingVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        foldersVM = FoldersListingVM.init(parent: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
