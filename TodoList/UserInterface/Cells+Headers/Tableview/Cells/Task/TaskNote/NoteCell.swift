//
//  NoteCell.swift
//  TodoList
//
//  Created by Usama Jamil on 07/08/2019.
//  Copyright © 2019 Usama Jamil. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    
    @IBOutlet weak var txtNote  : UITextView!
    @IBOutlet weak var imgNote  : UIImageView!
    
    var taskDetailVM            = TaskDetailVM()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        txtNote.delegate = self
        txtNote.returnKeyType = .done
        txtNote.textContainer.lineBreakMode = .byTruncatingTail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(viewModel: TaskDetailVM) {
        taskDetailVM = viewModel
        txtNote.text = viewModel.taskData.value.note?.replacingOccurrences(of: "\n", with: " ")
        self.setHighlighted()
    }
    
    func setHighlighted() {
        if !txtNote.text.isEmpty {
            imgNote.isHighlighted = true
        }
    }
    
}


extension NoteCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.setHighlighted()
        return true
    }
    
}
