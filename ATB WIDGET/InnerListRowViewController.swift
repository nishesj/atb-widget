//
//  ListRowViewController.swift
//  ATB WIDGET
//
//  Created by Nishes Joshi on 12/11/2017.
//  Copyright © 2017 Nishes Joshi. All rights reserved.
//

import Cocoa
import NotificationCenter

class InnerListRowViewController: NSViewController {
    
    
    @IBOutlet weak var busLabel: NSTextField!
    @IBOutlet weak var departureTime: NSTextField!
    @IBOutlet weak var destinationLabel: NSTextField!
    
    var departure : Departure?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ListRowViewController")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        
    }
    
}

