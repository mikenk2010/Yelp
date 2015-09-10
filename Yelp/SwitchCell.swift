//
//  SwitchCell.swift
//  Yelp
//
//  Created by Bao Nguyen on 9/10/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
   
    @IBOutlet weak var choiceLabel: UILabel!
    
    @IBOutlet weak var choiceImageView: UIImageView!
    var onChecked = false
    
    @IBOutlet weak var seeAllLabel: UILabel!
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.switchCell?(self, didChangeValue: onSwitch.on)
    }
}

