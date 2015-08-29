//
//  AcknowledgementViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/17/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit

class AcknowledgementViewController: UIViewController {

    // MARK: - View Methods (overridden)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    @IBAction func icon8LinkTapped(sender: UITapGestureRecognizer) {
        openUrl("https://icons8.com/license/")
    }

    // MARK: - Helper functions
    func openUrl(url: String) -> Void {
        let targetUrl = NSURL(string: url)
        let application = UIApplication.sharedApplication()
        application.openURL(targetUrl!)
    }
}
