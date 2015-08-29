//
//  TipDetailsViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit
import MapKit

class TipDetailsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var billAmountLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipValueLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var restaurantLocationMap: MKMapView!

    // MARK: Variables
    var tipHistoryRecord: TipHistory? = nil
    let regionRadius: CLLocationDistance = 1000

    var currencyFormatter = NSNumberFormatter()

    // MARK: View Methods (overridden)
    override func viewDidLoad() {
        currencyFormatter.numberStyle = .CurrencyStyle
        if tipHistoryRecord != nil {
            currencyFormatter.locale = NSLocale(localeIdentifier: tipHistoryRecord?.localeIdentifier ?? "en_US")
            updateAllLabels()
        }
    }

    override func viewDidAppear(animated: Bool) {
        animatedValueLabelsShow()
        updateMapLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Internal helper methods

    func animatedValueLabelsShow() {

        UIView.animateWithDuration(0, animations: { () -> Void in
            self.dateLabel.alpha = 1
            self.referenceLabel.alpha = 1
            self.billAmountLabel.alpha = 1
            self.tipValueLabel.alpha = 1
            self.totalAmountLabel.alpha = 1
            self.tipPercentLabel.alpha = 1
        })
    }

    func updateAllLabels() {
        dateLabel.text = TipCalUtils.getFormattedDate((tipHistoryRecord?.dateSaved)!)
        referenceLabel.text = tipHistoryRecord?.reference
        billAmountLabel.text = currencyFormatter.stringFromNumber((tipHistoryRecord?.billAmount)!)
        tipValueLabel.text = currencyFormatter.stringFromNumber((tipHistoryRecord?.tipValue)!)
        totalAmountLabel.text = currencyFormatter.stringFromNumber((tipHistoryRecord?.totalAmount)!)
        let tipPercent = (tipHistoryRecord?.tipPercent)!
        tipPercentLabel.text = "(\(tipPercent)%)"
    }

    func updateMapLocation() {
        if let resLatitude = tipHistoryRecord?.locationLatitude, resLogitude = tipHistoryRecord?.locationLongitude {
            restaurantLocationMap.alpha = 1
            let initialLocation = CLLocation(latitude: CLLocationDegrees(resLatitude), longitude: CLLocationDegrees(resLogitude))
            centerMapOnLocation(initialLocation)
        }
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        restaurantLocationMap.setRegion(coordinateRegion, animated: true)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        dropPin.title = tipHistoryRecord?.reference
        restaurantLocationMap.addAnnotation(dropPin)
    }
}
