//
//  FoldersListingVM.swift
//  TodoList
//
//  Created by Usama Jamil on 26/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class FoldersListingVM: NSObject {

    
    var parentVC  = FoldersListingVC()
    
    
    init(parent: FoldersListingVC) {
        super.init()
        
        self.parentVC = parent
        self.viewConfiguration()
    }
    
    func viewConfiguration() {
        
        parentVC.setDefaults(App.navTitles.foldersList, rightStr: nil)
        parentVC.setNavigationBar(parentVC)
        
        parentVC.foldersAdapter = FoldersAdapter.init(tableView: parentVC.foldersTableView, fetchedData: [""], controller: parentVC)
    }
    
}
