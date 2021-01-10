//
//  TaskTableViewCell.swift
//  SimpleToDoApp
//
//  Created by Yuki Tsukada on 2021/01/10.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var isCompletedLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with task: Task) {
        if task.isCompleted == true {
            isCompletedLabel.text = "✔️"
        } else {
            isCompletedLabel.text = ""
        }
        nameLabel.text = task.title
        descriptionLabel.text = task.todoDescription
    }

}
