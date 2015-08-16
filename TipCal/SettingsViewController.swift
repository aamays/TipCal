//
//  SettingsViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipPrecentLabel: UILabel!
    @IBOutlet weak var defaultTipSlider: UISlider!

    var onDefaultTipChanged : (() -> ())?

    // tip percent values
    var tipPercent:Float = 0.0 {
        didSet(oldVal) {
            // set current % value for the tip
            defaultTipPrecentLabel.text = String(format: "%.0f%%", tipPercent)
            defaultTipSlider.value = tipPercent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tipPercent = NSUserDefaults.standardUserDefaults().floatForKey(TipCalConstants.defaultTipPercentKey)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultTipValueUpdated(sender: UISlider) {

        // round the slider value for discrete steps
        tipPercent = round(sender.value)

        // save default tip to user application default
        saveDefaultTipValue(tipPercent)
    }

    func saveDefaultTipValue(tipValue: Float) -> Void {
        // Method to save default tip percent to user setings        
        NSUserDefaults.standardUserDefaults().setFloat(tipValue, forKey: TipCalConstants.defaultTipPercentKey)
        onDefaultTipChanged!()
    }
      

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    
    
}
