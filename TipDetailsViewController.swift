//
//  TipDetailsViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit

class TipDetailsViewController: UIViewController {

    var tipHistoryRecord: TipHistory? = nil

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!


    var currencyFormatter = NSNumberFormatter()

    override func viewDidLoad() {
        currencyFormatter.numberStyle = .CurrencyStyle

        if tipHistoryRecord != nil {
            updateAllLabels()
        }
    }

    func updateAllLabels() {
        dateLabel.text = TipCalUtils.getFormattedDate((tipHistoryRecord?.dateSaved)!)
        referenceLabel.text = tipHistoryRecord?.reference
        billAmountLabel.text = currencyFormatter.stringFromNumber((tipHistoryRecord?.billAmount)!)
        tipValueLabel.text = currencyFormatter.stringFromNumber((tipHistoryRecord?.tipValue)!)
        totalAmountLabel.text = currencyFormatter.stringFromNumber((tipHistoryRecord?.totalAmount)!)
        let tipPercent = (tipHistoryRecord?.tipPercent)!
        tipTextLabel.text = "Tip (\(tipPercent)%)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
