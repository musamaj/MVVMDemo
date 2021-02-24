//
//  CategoriesAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 04/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class CategoriesAdapter: GenericRefreshControl {
    
    weak var categoriesTableView     : UITableView!
    var parentVC                     : CategoryListingVC?
    
    var arrHidden                   = [false, false, false]
    var categoryCells               = [CategoryCell.self, NewCategoryCell.self]
    
    init(tableView: UITableView, fetchedData:[String], controller: CategoryListingVC?) {
        super.init()
        
        parentVC = controller
        
        tableView.registerNib(from: CategoryCell.self)
        tableView.registerNib(from: NewCategoryCell.self)
        tableView.registerNib(from: CategoryHeader.self)
        
        categoriesTableView = tableView
        categoriesTableView.backgroundColor = UIColor.white
        
        categoriesTableView.rowHeight = UITableView.automaticDimension
        categoriesTableView.estimatedRowHeight = App.tableCons.estRowHeight
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.tableFooterView = UIView(frame: .zero)
        categoriesTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: categoriesTableView.frame.size.width, height: 0.01))
        
        //self.setupRefresh()
        categoriesTableView.reloadData()
    }
    
    func setupRefresh() {
        
        self.pageRequest = {
        }
        self.pullRequest = {
            Persistence.shared.isAppAlreadyLaunchedForFirstTime = true
            self.parentVC?.categoryVM.fetchData()
        }
        self.setupRefreshControls(adapter: self, tableView: categoriesTableView)
    }
    
    public func reloadAdapter() {
        self.categoriesTableView.reloadData()
    }
}

extension CategoriesAdapter : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 && !(parentVC?.categoryVM.categories.value[indexPath.row].synced ?? true) {
            return true
        }
        
        if indexPath.section == 0 && parentVC?.categoryVM.categories.value[indexPath.row].owner?.id == Persistence.shared.currentUserID {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            Utility.deleteCallBack = {
                self.parentVC?.categoryVM.delete(index: indexPath.row)
            }
            Utility.showDeletion()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 2 {
            if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoryHeader.identifier) as? CategoryHeader {
                headerView.viewConfiguration(adapter: self, section: section)
                return headerView
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section > 2 {
            return App.tableCons.estHeaderHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if arrHidden[section] {
            return 0
        }
        let rows = section == 0 ? (parentVC?.categoryVM.categories.value.count ?? 0) : 1
        return rows
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : ParentCategoryCell = tableView.dequeue(cell: categoryCells[indexPath.section]) else { return UITableViewCell() }
        let title = indexPath.section == 0 ? parentVC?.categoryVM.categories.value[indexPath.row].name : CategoryStrs.create
        cell.populateData(title: title ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension CategoriesAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            parentVC?.navigateToCategoryCreation()
        } else {
            if let category = parentVC?.categoryVM.categories.value[indexPath.row] {
                let item = parentVC?.categoryVM.categoryItems[indexPath.row]
                parentVC?.navigateToTasksListing(category: category, item: item)
            }
        }
    }
}
