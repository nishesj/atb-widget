//
//  ListRowViewController.swift
//  ATB WIDGET
//
//  Created by Nishes Joshi on 12/11/2017.
//  Copyright © 2017 Nishes Joshi. All rights reserved.
//

import Cocoa

class ListRowViewController: NSViewController {
    
    @IBOutlet weak var scrollViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var disclosureButton: NSButton!
    
    @IBOutlet weak var titleTextField: NSTextFieldCell!
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    @IBAction func clicked(_ sender: NSButton) {
        if (sender.state == NSControl.StateValue.on) {
            let h  = Int(ceil(tableView.rowHeight));
            scrollViewConstraint.constant = CGFloat(h * (departureResponse?.departures.count)!) + 25
        } else {
            scrollViewConstraint.constant = 0
        }
    }
    
    var departureResponse : DepartureResponse?
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ListRowViewController")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        if let busStop = departureResponse?.busStop {
            var truncated = String(busStop.description.dropLast(10)).trimmingCharacters(in: [" "])
            truncated.append((departureResponse?.isGoingTowardsCentrum)! ? " : Til sentrum " : " : Fra sentrum ");
            titleTextField.stringValue = truncated
        }
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
    }
}

extension ListRowViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let departures = departureResponse?.departures {
            return departures.count;
        }
        return 0;
    }
    
    fileprivate enum CellIdentifiers {
        static let lineCell = "line"
        static let departureTimeCell = "time"
        static let destinationCell = "destination"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let item = departureResponse?.departures[row] else {
            return nil
        }
        
        if tableColumn == tableView.tableColumns[0] {
            text = item.line!
            cellIdentifier = CellIdentifiers.lineCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = item.destination!
            cellIdentifier = CellIdentifiers.departureTimeCell
        } else if tableColumn == tableView.tableColumns[2] {
            let dateformatter = DateFormatter()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm";
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let parsedDate = dateformatter.date(from: (item.registeredDepartureTime)!)
            text = timeFormatter.string(from: parsedDate!)
            cellIdentifier = CellIdentifiers.departureTimeCell
        }
        
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.alphaValue = item.isRealtimeData ? 1 : 0.5
            return cell
        }
        return nil
    }
    
    
}
