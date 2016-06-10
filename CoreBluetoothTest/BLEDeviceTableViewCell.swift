//
//  BLEDeviceTableViewCell.swift
//  CoreBluetoothTest
//
//  Created by Paolo Longato on 17/04/2016.
//  Copyright © 2016 Paolo Longato. All rights reserved.
//

import UIKit

class BLEDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
