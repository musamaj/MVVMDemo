//
//  TitleCell.swift
//  TodoList
//
//  Created by Usama Jamil on 11/07/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class TitleCell: ParentSectionCell {

    @IBOutlet weak var txtTitle : UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populateData(viewModel : AnyObject, _ index: Int = 0) {
        let controller = UIApplication.topViewController() as? CategoryCreationVC
        txtTitle.text = controller?.categoryVM.categoryData.value.name ?? ""
    }
    
}
