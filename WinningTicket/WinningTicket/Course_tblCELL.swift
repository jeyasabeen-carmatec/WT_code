//
//  Course_tblCELL.swift
//  WinningTicket
//
//  Created by Test User on 13/07/17.
//  Copyright © 2017 Test User. All rights reserved.
//

import UIKit

class Course_tblCELL: UITableViewCell {
    @IBOutlet weak var lbl_courseName: UILabel!
    @IBOutlet weak var lbl_privacy: UILabel!
    @IBOutlet weak var lbl_id: UILabel!
    @IBOutlet weak var IMG_privacy: UIImageView!
    @IBOutlet weak var IMG_courseimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
