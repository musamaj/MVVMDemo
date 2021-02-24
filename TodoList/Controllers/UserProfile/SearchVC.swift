//
//  SearchVC.swift
//  TodoList
//
//  Created by Usama Jamil on 29/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class SearchVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        self.setNavBar()
    }

    
    func setNavBar() {
        
        leftImg = #imageLiteral(resourceName: "ic_search")
        rightTitle = App.barItemTitles.cancel
        rightTint  = .white
        setNavigationBar(self)
        
        let txtSearch = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
        txtSearch.placeholder = "Search.."
        txtSearch.backgroundColor = .white  //AppTheme.navBarthemeColor()
        //txtSearch.sizeToFit()
        
        let leftNavBarButton = UIBarButtonItem(customView:txtSearch)
        self.navigationItem.leftBarButtonItems = [leftButton, leftNavBarButton]
        
        //self.navigationItem.titleView = txtSearch
        
    }
    
}
