//
//  TipCalUtils.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import Foundation

class TipCalUtils {

    static func getUserDirectory() -> String {
        let userDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return userDir[0] as! String
    }

    static func getLastBillArchiveFile() -> String {
        return "\(TipCalUtils.getUserDirectory())/\(TipCalConstants.lastBillArchiveFileName)"
    }

    static func getFormattedDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(date)
    }

    static func getAppVersionString() -> String {
        return (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String)!
    }
}