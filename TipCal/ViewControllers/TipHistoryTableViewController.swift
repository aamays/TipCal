//
//  TipHistoryTableViewController.swift
//  TipCal
//
//  Created by Amay Singhal on 8/16/15.
//  Copyright (c) 2015 AKS. All rights reserved.
//

import UIKit
import CoreData

class TipHistoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    // currency formatter
    var currencyFormatter = NSNumberFormatter()

    let context: NSManagedObjectContext  = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()


    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // set currency formatter
        currencyFormatter.numberStyle = .CurrencyStyle

        fetchedResultsController = getTipHistoryFetchedResultsController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
        animateLoadingTable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper functions
    func getTipHistoryFetchedResultsController() -> NSFetchedResultsController {
        return NSFetchedResultsController(fetchRequest: tipHistoryFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }

    func tipHistoryFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: TipCalConstants.tipHistoryEntityName)
        let sortDescriptor = NSSortDescriptor(key: "dateSaved", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        animateLoadingTable()
    }

    func animateLoadingTable() {
        // Method to animate table loading
        tableView.reloadData()

        let visibleCells = tableView.visibleCells()
        let tableHeight: CGFloat = tableView.bounds.size.height

        for tableCell in visibleCells {
            let cell: UITableViewCell = tableCell as! UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }

        var index = 0

        for tableCell in visibleCells {
            let cell: UITableViewCell = tableCell as! UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            index += 1
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        let numberOfSections = fetchedResultsController.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let numberOfRowsInSection = fetchedResultsController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tipRecordCell", forIndexPath: indexPath) as! TipHistoryTableCell

        let tipHistory = fetchedResultsController.objectAtIndexPath(indexPath) as! TipHistory

        // Configure the cell...
        cell.referenceLabel.text = tipHistory.reference
        currencyFormatter.locale = NSLocale(localeIdentifier: tipHistory.localeIdentifier)
        cell.totalAmountLabel.text = currencyFormatter.stringFromNumber(tipHistory.totalAmount)
        cell.dateLabel.text = TipCalUtils.getFormattedDate(tipHistory.dateSaved)

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        let managedObject: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        context.deleteObject(managedObject)
        context.save(nil)
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let tipDetailVC = segue.destinationViewController as? TipDetailsViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            tipDetailVC.tipHistoryRecord = fetchedResultsController.objectAtIndexPath(indexPath!) as? TipHistory
        }
    }
}
