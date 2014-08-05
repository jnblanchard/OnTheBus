//
//  BusStopViewController.swift
//  OnTheBus
//
//  Created by John Blanchard on 8/5/14.
//  Copyright (c) 2014 John Blanchard. All rights reserved.
//

import UIKit

class BusStopViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var dict:NSDictionary!

    @IBOutlet weak var interModalLabel: UILabel!
    @IBOutlet weak var routesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        println("\(self.dict)")
        nameLabel.text = dict["cta_stop_name"] as String

        routesLabel.text = dict["routes"] as String
        interModalLabel.text = dict["inter_modal"] as? String
        interModalLabel.backgroundColor = UIColor.yellowColor()
    }

}
