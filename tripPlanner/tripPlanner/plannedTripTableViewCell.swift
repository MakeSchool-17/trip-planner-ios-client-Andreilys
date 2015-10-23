//
//  plannedTripTableViewCell.swift
//  tripPlanner
//
//  Created by Andrei Lyskov on 10/22/15.
//  Copyright © 2015 Andrei Lyskov. All rights reserved.
//

import UIKit

class plannedTripTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print(self.tag)
        if (self.tag == 1){
            print("ok")
        }
        // Configure the view for the selected state
    }

}
