//
//  CategoryHeader.swift
//  TodoList
//
//  Created by Usama Jamil on 05/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class CategoryHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnSection   : UIButton!
    
    var parent                      : CategoriesAdapter?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    func viewConfiguration(adapter: CategoriesAdapter, section: Int) {
        self.parent = adapter
        self.btnSection.tag = section
        self.lblTitle.text  = CategoryStrs.foldersArr[section]
        self.btnSection.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
    }

    @objc func toggleExpand(sender: UIButton) {
        parent?.arrHidden[sender.tag] = !(parent?.arrHidden[sender.tag] ?? false)
        parent?.categoriesTableView.reloadSections(IndexSet.init(integer: sender.tag), with: .fade)
    }
    
}
