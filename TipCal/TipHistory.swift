//
//  TipHistory.swift
//  TipCal
//
//  Created by Amay Singhal on 8/26/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import Foundation
import CoreData
@objc(TipHistory)
class TipHistory: NSManagedObject {

    @NSManaged var billAmount: NSNumber
    @NSManaged var dateSaved: NSDate
    @NSManaged var localeIdentifier: String
    @NSManaged var reference: String
    @NSManaged var shareAmount: NSNumber
    @NSManaged var shareCount: NSNumber
    @NSManaged var tipPercent: NSNumber
    @NSManaged var tipValue: NSNumber
    @NSManaged var totalAmount: NSNumber
    @NSManaged var locationText: String
    @NSManaged var locationLatitude: NSNumber
    @NSManaged var locationLongitude: NSNumber

}
