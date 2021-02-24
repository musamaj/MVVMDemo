//
//  NewFolderCell.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NewFolderCell: UITableViewCell {

    @IBOutlet weak var txtFolderName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actCreateFolder(_ sender: Any) {
        if txtFolderName.isValid() {
            CategoryStrs.foldersArr.append(txtFolderName.text ?? "")
            txtFolderName.text = ""
            self.tableView?.reloadData()
        }
    }
    
}
