//
//  ProfileItemCell.swift
//  TodoList
//
//  Created by Usama Jamil on 31/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class ProfileItemCell: UITableViewCell {

    
    @IBOutlet weak var imgProfileItem   : UIImageView!
    @IBOutlet weak var lblItemTitle     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(img: UIImage?, title: String) {
        imgProfileItem.image = img
        lblItemTitle.text    = title
    }
    
}
