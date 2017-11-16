//
//  ListRowViewController.swift
//  ATB WIDGET
//
//  Created by Nishes Joshi on 12/11/2017.
//  Copyright © 2017 Nishes Joshi. All rights reserved.
//

import Cocoa

class ListRowViewController: NSViewController {
    
    @IBOutlet weak var busLabel: NSTextField!
    @IBOutlet weak var departureTime: NSTextField!
    @IBOutlet weak var destinationLabel: NSTextField!
    
    var departure : Departure?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ListRowViewController")
    }
    
    override func loadView() {
        super.loadView()
        
        if (self.departure != nil) {
            let dateformatter = DateFormatter()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm";
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            busLabel.stringValue = (self.departure?.line)!
            let parsedDate = dateformatter.date(from: (self.departure?.registeredDepartureTime)!)
            departureTime.stringValue = timeFormatter.string(from: parsedDate!)
            destinationLabel.stringValue = (self.departure?.destination!)!
        }
    }
    
    override func viewDidLoad() {
    }
    
}
