//
//  BillCell.swift
//  XTsplit
//
//  Created by Kevin Linne on 10.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell {
    
    var bill: Bill!
    
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
    
    func configureCell(bill: Bill, color: UIColor) {
        self.bill = bill
        
        self.nameLabel.text = bill.name
        self.bgView.backgroundColor = color
        
        var userString = ""
        
        for user in bill.receiver {
            userString.append("\(user.username) ,")
        }
        
        usersLabel.text = userString.substring(to: userString.index(before: userString.endIndex))
        
        sumLabel.text = "\(bill.value) €"
        
    }
    
}
