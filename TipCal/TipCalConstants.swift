//
//  TipCalConstans.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import Foundation
import UIKit

class TipCalConstants {

    // MARK: - Resource constants
    static let tipCalPlistResouceName = "TipCal"
    static let defaultTipPercentKey = "defaultTipPercent"
    static let avgCostPerPersonKey = "avgCostPerPerson"
    static let lastBillArchiveFileName = "lastbillamount"
    static let tipHistoryEntityName = "TipHistory"
    static let themeColorOptionKey = "themeColor"

    // MARK: - General Text
    static let notAvailableText = "N/A";

    // MARK: - App logic contants
    static let maxSecondsElapsedToReload = 600
    static let defaultShareCountSliderValue:Float = 25.0

    // MARK: - UI Contants
    // valid value text color
    static let numTextUIColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    // place holder text color
    static let placeHolderTextColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)

    // theme colors
    static let whiteThemeColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let skyThemeColor = UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1)
    static let spindriftThemeColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 1)
    static let honeydrewThemeColor = UIColor(red: 204/255, green: 255/255, blue: 102/255, alpha: 1)
    static let cantaloupeThemeColor = UIColor(red: 255/255, green: 204/255, blue: 102/255, alpha: 1)

    static let themeColors = [whiteThemeColor, skyThemeColor, spindriftThemeColor, honeydrewThemeColor, cantaloupeThemeColor]

}