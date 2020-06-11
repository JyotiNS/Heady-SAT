//
//  Utils.swift
//  Technosoft Intelligent System
//
//  Created by Jyoti Sanvake on 08/05/20.
//  Copyright © 2020 Technosoft Engineering Projects Ltd. All rights reserved.
//

import Foundation

class Utils {
    
    static func getDate(dateString : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString) // replace Date String
    }
    static func getDateInString(date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    static func getDateInDouble(date : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        
        return dateFormatter.string(from: date)
    }


}
