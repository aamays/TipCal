//
//  CalculatorViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit
import CoreData

class CalculatorViewController: UIViewController {

    // MARK: - Outlets
    // outlets
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var tipDetailsView: UIView!
    @IBOutlet weak var totalDetailsView: UIView!
    @IBOutlet weak var amtShareDetailsView: UIView!
    @IBOutlet weak var shareAmountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var shareCountSlider: UISlider!


    // MARK: - Class Variables
    // currency formatter
    var currencyFormatter = NSNumberFormatter()

    // varibale for bill amount
    var billAmount: Double {
        get {
            return round((billAmountTextField.text!.stringByReplacingOccurrencesOfString(currencyFormatter.currencySymbol!, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.groupingSeparator, withString: "").stringByReplacingOccurrencesOfString(currencyFormatter.decimalSeparator!, withString: ".") as NSString).doubleValue * 100)/100
        }
        set(newValue) {
            billAmountTextField.text = currencyFormatter.stringFromNumber(newValue)
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

    // variable for split count
    var splitCount = 1 {
        didSet(oldValue) {
            shareCountLabel.text = "\(splitCount) share(s)"
            shareCountLabel.textColor = UIColor.darkGrayColor()

            if splitCount >= Int(shareCountSlider.minimumValue) && splitCount <= Int(shareCountSlider.maximumValue) {
                shareCountSlider.value = Float(splitCount)
            } else {
                shareCountSlider.value = TipCalConstants.defaultShareCountSliderValue
            }
        }
    }

    // variable for share amount per person
    var splitAmount = 0.0 {
        didSet(oldValue) {
            shareAmountLabel.text = currencyFormatter.stringFromNumber(splitAmount)
            shareAmountLabel.textColor = TipCalConstants.numTextUIColor
        }
    }

    var updateTipPercentWithDefault: Bool!
    var shareCountManuallySet = false

    var avgSharePerPerson = NSUserDefaults.standardUserDefaults().integerForKey(TipCalConstants.avgCostPerPersonKey)

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    // MARK: - Overriden View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currencyFormatter.numberStyle = .CurrencyStyle

        // Check if any last saved amount exits
        if !checkAndLoadLastSavedBillFromArchive() {
            updateTipPercentWithDefault = true
        }

        beginLabelViewAnnimation()
    }

    override func viewWillAppear(animated: Bool) {
        billAmountTextField.becomeFirstResponder()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Update share
        avgSharePerPerson = NSUserDefaults.standardUserDefaults().integerForKey(TipCalConstants.avgCostPerPersonKey)
        updateShareAmount()

        // Update tip
        if updateTipPercentWithDefault ?? false {
            setTipPercentToDefault()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func billAmountUpdated(sender: UITextField) {
        updateTipAndTotal()
    }

    @IBAction func screenTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func tipViewSwipped(swipeGesture: UISwipeGestureRecognizer) {
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.Right:
            tipPercent == 100 ? shakeUIView(tipDetailsView) : ()
            tipPercent += (tipPercent < 100.0) ? 1 : 0
        case UISwipeGestureRecognizerDirection.Left:
            tipPercent == 0 ? shakeUIView(tipDetailsView) : ()
            tipPercent -= (tipPercent > 0.0) ? 1 : 0
        default:
            break
        }
        updateTipPercentWithDefault = false
    }
    
    @IBAction func totalViewLongPressed(sender: UILongPressGestureRecognizer) {
        if count(billAmountTextField.text) > 0 {
            presentSaveRecordAlertView()
        } else {
            shakeUIView(totalDetailsView)
        }
    }

    @IBAction func shareCountChanged(sender: UISlider) {
        var sliderValue = sender.value
        splitCount = Int(round(sliderValue))
        shareCountManuallySet = true
        updateShareAmount()
        archiveLastBillAmount()
    }

    // MARK: - Internal Helper Functions
    func beginLabelViewAnnimation() {
        tipDetailsView.center.y += 500
        totalDetailsView.center.y += 500
        amtShareDetailsView.center.y += 500

        // UIView.animateWithDuration(1.0, animations: )
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 7, options: nil, animations: ({
                    self.tipDetailsView.center.y -= 500
                }), completion: nil)

        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 8, options: nil, animations: ({
            self.totalDetailsView.center.y -= 500
        }), completion: nil)

        UIView.animateWithDuration(2.0, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 8, options: nil, animations: ({
            self.amtShareDetailsView.center.y -= 500
        }), completion: nil)
    }

    func setTipPercentToDefault() {
        tipPercent = NSUserDefaults.standardUserDefaults().doubleForKey(TipCalConstants.defaultTipPercentKey)
    }

    func updateTipAndTotal() -> Void {
        // method to update tip percent and total value and their associated labels
        if count(billAmountTextField.text) > 0 {
            tipValue = billAmount * tipPercent/100
            totalBillAmount = billAmount + tipValue
            updateShareAmount()
            archiveLastBillAmount()
        } else {
            resetLabel(tipValueLabel, text: "Tip")
            resetLabel(totalValueLabel, text: "Total")
            resetLabel(shareAmountLabel, text: "Share")
            shareCountManuallySet = false
        }
    }

    func updateShareAmount() -> Void {
        // Method to update share amount
        if count(billAmountTextField.text) > 0 {
            if !shareCountManuallySet {
                splitCount = Int(totalBillAmount)/avgSharePerPerson
                splitCount = splitCount != 0 ? splitCount : 1
            }

            splitAmount = totalBillAmount/Double(splitCount)
        }
    }

    func resetLabel(label: UILabel, text: String) -> Void {
        label.text = text
        label.textColor = TipCalConstants.placeHolderTextColor
    }

    func presentSaveRecordAlertView() -> Void {
        
        //1. Create the alert controller.
        var alert = UIAlertController(title: "Save Bill Record", message: "Reference (e.g. Restaurant Name)", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            if count(textField.text) > 0 {
                self.saveBillRecord(textField.text)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func shakeUIView(targetView: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(targetView.center.x - 10, targetView.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(targetView.center.x + 10, targetView.center.y))
        targetView.layer.addAnimation(animation, forKey: "position")
    }

    // MARK: - Persistence
    func archiveLastBillAmount() -> Void {
        let lastBillAmount = LastBillAmount()
        lastBillAmount.billAmount = billAmount
        lastBillAmount.tipPercent = tipPercent
        lastBillAmount.dateSaved = NSDate()
        lastBillAmount.shareCount = Int32(splitCount)


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
                splitCount = Int(lastBillAmount.shareCount)
                shareCountManuallySet = true
                billLoadedFromArchive = true
            }
        } else {
            NSLog("Something went wrong while loading last saved bill!!!")
        }
        return billLoadedFromArchive
    }

    func saveBillRecord(billReference: String) -> Void {

        let ent = NSEntityDescription.entityForName(TipCalConstants.tipHistoryEntityName, inManagedObjectContext: self.context!)
        let tipHistoryRecord = TipHistory(entity: ent!, insertIntoManagedObjectContext: self.context)
        tipHistoryRecord.billAmount = billAmount
        tipHistoryRecord.tipPercent = tipPercent
        tipHistoryRecord.tipValue = tipValue
        tipHistoryRecord.totalAmount = totalBillAmount
        tipHistoryRecord.dateSaved = NSDate()
        tipHistoryRecord.shareCount = splitCount
        tipHistoryRecord.shareAmount = splitAmount
        tipHistoryRecord.reference = billReference
        tipHistoryRecord.localeIdentifier = NSLocale.currentLocale().localeIdentifier

        // save the object
        self.context?.save(nil)

    }

    // MARK: - Navigation

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

