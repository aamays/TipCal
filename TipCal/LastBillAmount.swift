//
//  LastBillAmount.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import Foundation

class LastBillAmount: NSObject, NSCoding {

    var billAmount: Double!
    var tipPercent: Double!
    var shareCount: Int32!
    var dateSaved: NSDate!
    
    // MARK: NSCoding
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.billAmount = decoder.decodeDoubleForKey("billAmount") as Double
        self.tipPercent = decoder.decodeDoubleForKey("tipPercent") as Double
        self.shareCount = decoder.decodeInt32ForKey("shareCount") as Int32
        self.dateSaved = decoder.decodeObjectForKey("dateSaved") as! NSDate
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeDouble(self.billAmount, forKey: "billAmount")
        coder.encodeDouble(self.tipPercent, forKey: "tipPercent")
        coder.encodeInt(self.shareCount, forKey: "shareCount")
        coder.encodeObject(self.dateSaved, forKey: "dateSaved")

    }

}
