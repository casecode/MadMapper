//
//  ReminderCell.swift
//  MadMapper
//
//  Created by Casey R White on 11/5/14.
//  Copyright (c) 2014 casecode. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var reminderNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
