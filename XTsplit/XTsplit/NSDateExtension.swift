//
//  NSDateExtension.swift
//  XTsplit
//
//  Created by Kevin Linne on 03.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import Foundation

extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "de_DE") as Locale!
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}
