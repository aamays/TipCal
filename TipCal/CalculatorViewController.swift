//
//  CalculatorViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    // outlets
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!

    // currency formatter
    var currencyFormatter = NSNumberFormatter()

    // varibale for bill amount
    var billAmount: Double {
        get {
            return round((billAmountTextField.text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol!, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator!, withString: ".") as NSString).doubleValue * 100)/100
        }
        set(newValue) {
            billAmountTextField.text = "\(newValue)"
        }
    
    }

    // var tip percent value
    var tipPercent = 0.0 {
        didSet(oldTipPercent) {
            tipPercentLabel.text = String(format: "(%.0f%%)", tipPercent)
            updateTipAndTotal()
        }
    }
    
    // variable for tip value
    var tipValue = 0.0 {
        willSet(newTipValue) {
            tipValueLabel.text = currencyFormatter.stringFromNumber(newTipValue)
            tipValueLabel.textColor = TipCalConstants.numTextUIColor
        }
    }

    // varaible for total value
    var totalBillAmount = 0.0 {
        willSet(newTotal) {
            totalValueLabel.text = currencyFormatter.stringFromNumber(newTotal)
            totalValueLabel.textColor = TipCalConstants.numTextUIColor
        }
    }

    var updateTipPercentWithDefault: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currencyFormatter.numberStyle = .CurrencyStyle

        // Check if any last saved amount exits
        if !checkAndLoadLastSavedBillFromArchive() {
            updateTipPercentWithDefault = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        billAmountTextField.becomeFirstResponder()
        println(updateTipPercentWithDefault)
        if updateTipPercentWithDefault ?? false {
            setTipPercentToDefault()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func billAmountUpdated(sender: UITextField) {
        updateTipAndTotal()
    }

    func setTipPercentToDefault() {
        tipPercent = NSUserDefaults.standardUserDefaults().doubleForKey(TipCalConstants.defaultTipPercentKey)
    }

    func updateTipAndTotal() -> Void {
        // method to update tip percent and total value and their associated labels
        if count(billAmountTextField.text) > 0 {
            tipValue = billAmount * tipPercent/100
            totalBillAmount = billAmount + tipValue
            archiveLastBillAmount()
        } else {
            resetLabel(tipValueLabel, text: "Tip")
            resetLabel(totalValueLabel, text: "Total")
        }
    }
    
    func resetLabel(label: UILabel, text: String) -> Void {
        label.text = text
        label.textColor = TipCalConstants.placeHolderTextColor
    }

    func archiveLastBillAmount() -> Void {
        let lastBillAmount = LastBillAmount()
        lastBillAmount.billAmount = billAmount
        lastBillAmount.tipPercent = tipPercent
        lastBillAmount.dateSaved = NSDate()
        lastBillAmount.shareCount = 1


        if !NSKeyedArchiver.archiveRootObject(lastBillAmount, toFile: TipCalUtils.getLastBillArchiveFile()) {
            NSLog("Could not archive last bill amount")
        }

    }

    func checkAndLoadLastSavedBillFromArchive() -> Bool {
        var billLoadedFromArchive = false
        if let lastBillAmount = NSKeyedUnarchiver.unarchiveObjectWithFile(TipCalUtils.getLastBillArchiveFile()) as? LastBillAmount {
            if Int(NSDate().timeIntervalSinceDate(lastBillAmount.dateSaved)) < TipCalConstants.maxSecondsElapsedToReload {
                billAmount = lastBillAmount.billAmount
                tipPercent = lastBillAmount.tipPercent
                billLoadedFromArchive = true
            }
        } else {
            NSLog("Something went wrong while loading last saved bill!!!")
        }
        return billLoadedFromArchive
    }

    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func tipViewSwipped(swipeGesture: UISwipeGestureRecognizer) {
       
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.Right:
            tipPercent += (tipPercent < 100.0) ? 1 : 0
        case UISwipeGestureRecognizerDirection.Left:
            tipPercent -= (tipPercent > 0.0) ? 1 : 0
        default:
            break
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let settingsVC = segue.destinationViewController as? SettingsViewController {
            settingsVC.onDefaultTipChanged = {[weak self]() in
                if let weakSelf = self {
                    weakSelf.updateTipPercentWithDefault = true
                }
            }
        }
    }
}

