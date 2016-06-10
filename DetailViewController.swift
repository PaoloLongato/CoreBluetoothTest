//
//  DetailViewController.swift
//  CoreBluetoothTest
//
//  Created by Paolo Longato on 18/04/2016.
//  Copyright © 2016 Paolo Longato. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    var services = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataLabel.text = services.description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
