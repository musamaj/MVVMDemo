//
//  FoldersAdapter.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit


class FoldersAdapter: NSObject {
    
    weak var foldersTableView        : UITableView!
    var parentVC                     : UIViewController?
    
    
    init(tableView: UITableView, fetchedData:[String], controller: UIViewController?) {
        super.init()
        
        parentVC = controller
        
        tableView.registerNib(from: FolderDetailCell.self)
        tableView.registerNib(from: NewFolderCell.self)
        
        foldersTableView = tableView
        foldersTableView.backgroundColor = .white
        
        foldersTableView.estimatedRowHeight = App.tableCons.defaultHeight
        foldersTableView.delegate = self
        foldersTableView.dataSource = self
        foldersTableView.tableFooterView = UIView(frame: .zero)
        foldersTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: foldersTableView.frame.size.width, height: 0.01))
        
        foldersTableView.reloadData()
        
    }
    
    public func reloadAdapter() {
        self.foldersTableView.reloadData()
    }
}

extension FoldersAdapter : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CategoryStrs.foldersArr.count+2
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : FolderDetailCell = tableView.dequeue(cell: FolderDetailCell.self) else { return UITableViewCell() }
        if indexPath.row == 0 {
            return cell
        } else if indexPath.row == 1 {
            guard let cell : NewFolderCell = tableView.dequeue(cell: NewFolderCell.self) else { return UITableViewCell() }
            return cell
        } else {
            cell.lblFolderName.text = CategoryStrs.foldersArr[indexPath.row-2]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryStrs.tableCons.defaultHeight
    }
    
}

extension FoldersAdapter : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
