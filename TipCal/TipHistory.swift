//
//  TipHistory.swift
//  
//
//  Created by Amay Singhal on 8/17/15.
//
//

import Foundation
import CoreData
@objc(TipHistory)
class TipHistory: NSManagedObject {

    @NSManaged var billAmount: NSNumber
    @NSManaged var dateSaved: NSDate
    @NSManaged var shareAmount: NSNumber
    @NSManaged var shareCount: NSNumber
    @NSManaged var tipPercent: NSNumber
    @NSManaged var tipValue: NSNumber
    @NSManaged var totalAmount: NSNumber
    @NSManaged var reference: String
    @NSManaged var localeIdentifier: String

}
