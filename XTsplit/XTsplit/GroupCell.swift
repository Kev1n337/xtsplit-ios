//
//  GroupCell.swift
//  XTsplit
//
//  Created by Kevin Linne on 02.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {
    
    var group: Group!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var usersLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(group: Group) {
        self.group = group
        
        self.nameLabel.text = group.name
        self.bgView.backgroundColor = group.color
        
        var userString = ""
        
        for user in group.participants! {
            userString.append("\(user.username) ,")
        }
        
        usersLabel.text = userString.substring(to: userString.index(before: userString.endIndex))
        
        sumLabel.text = "\(group.calculateSum()) €"
        
    }

}
