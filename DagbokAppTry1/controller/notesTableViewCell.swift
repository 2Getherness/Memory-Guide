//
//  notesTableViewCell.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-01-30.
//  Copyright © 2018 imran khan. All rights reserved.
//

import UIKit

class notesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
