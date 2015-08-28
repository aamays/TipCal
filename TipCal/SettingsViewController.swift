//
//  SettingsViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var defaultTipPrecentLabel: UILabel!
    @IBOutlet weak var defaultTipSlider: UISlider!
    @IBOutlet weak var avgAmountTextLabel: UILabel!
    @IBOutlet weak var avgAmountValueLabel: UITextField!
    @IBOutlet weak var appVersionLabel: UILabel!

    // MARK: - Variables
    var onDefaultTipChanged : (() -> ())?

    // tip percent values
    var tipPercent:Float = 0.0 {
        didSet(oldVal) {
            // set current % value for the tip
            defaultTipPrecentLabel.text = String(format: "%.0f%%", tipPercent)
            defaultTipSlider.value = tipPercent
        }
    }

    // currency formatter
    var currencyFormatter = NSNumberFormatter()

    // MARK: - View Methods (overridden)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currencyFormatter.numberStyle = .CurrencyStyle

        tipPercent = NSUserDefaults.standardUserDefaults().floatForKey(TipCalConstants.defaultTipPercentKey)
        avgAmountValueLabel.text = "\(NSUserDefaults.standardUserDefaults().integerForKey(TipCalConstants.avgCostPerPersonKey))"
        avgAmountTextLabel.text = "Avg. \(currencyFormatter.currencySymbol!)/person"

        appVersionLabel.text = "v\(TipCalUtils.getAppVersionString())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func defaultTipValueUpdated(sender: UISlider) {
        // round the slider value for discrete steps
        tipPercent = round(sender.value)

        // save default tip to user application default
        NSUserDefaults.standardUserDefaults().setFloat(tipPercent, forKey: TipCalConstants.defaultTipPercentKey)
        onDefaultTipChanged!()
    }

    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func avgAmountValueUpdated(sender: UITextField) {

        // save default tip to user application default
        if let newAvgCost = sender.text.toInt() {
            NSUserDefaults.standardUserDefaults().setInteger(newAvgCost, forKey: TipCalConstants.avgCostPerPersonKey)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    
    
}
