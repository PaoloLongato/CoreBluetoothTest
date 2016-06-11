//
//  BLEDeviceListController.swift
//  CoreBluetoothTest
//
//  Created by Paolo Longato on 17/04/2016.
//  Copyright © 2016 Paolo Longato. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEDeviceListController: UITableViewController {
    
    let bManager = BluetoothManager()
    var peripherals: [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bManager.listener = { [weak self] (perifs) in
            self?.peripherals = perifs
            self?.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CBPeripheralCell", forIndexPath: indexPath) as! BLEDeviceTableViewCell

        // Configure the cell...
        let perif = peripherals[indexPath.row]
        let services = perif.services?.first
        //cell.state.text = String(perif.state.rawValue)
        cell.state.text = "\(services)"
        cell.name.text = perif.name
        cell.id.text = perif.identifier.UUIDString
        
        if perif.name == "NoviPel4" {
           // print ("CARACTERISTCS = \(perif.services)")
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let s = sender as? DetailViewController {
            // SOME IMPLEMENTATION.  For now just a stub.
            // Need to extract services from the peripheral.  That can be done here or in the receiving view.  Achitectural choice.
        }
    }

}
