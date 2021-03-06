//
//  TodayViewController.swift
//  ATB WIDGET
//
//  Created by Nishes Joshi on 12/11/2017.
//  Copyright © 2017 Nishes Joshi. All rights reserved.
//

import Cocoa
import NotificationCenter
import CoreLocation

class DepartureViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var listViewController: NCWidgetListViewController!
    
    var departureRowViewController: DepartureRowViewController?
    
    // MARK: - NSViewController
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("DepartureViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the widget list view controller.
        // The contents property should contain an object for each row in the list.
        self.listViewController.contents = []
    }
    
    override func dismissViewController(_ viewController: NSViewController) {
        super.dismissViewController(viewController)
    }
    
    
    
    
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Refresh the widget's contents in preparation for a snapshot.
        // Call the completion handler block after the widget's contents have been
        // refreshed. Pass NCUpdateResultNoData to indicate that nothing has changed
        // or NCUpdateResultNewData to indicate that there is new data since the
        // last invocation of this method.
        completionHandler(.noData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInset: NSEdgeInsets) -> NSEdgeInsets {
        // Override the left margin so that the list view is flush with the edge.
        var newInsets = defaultMarginInset
        newInsets.left = 0
        return newInsets
    }
    
    var widgetAllowsEditing: Bool {
        // Return true to indicate that the widget supports editing of content and
        // that the list view should be allowed to enter an edit mode.
        return false
    }
    
    func widgetDidBeginEditing() {
        // The user has clicked the edit button.
        // Put the list view into editing mode.
        self.listViewController.editing = true
    }
    
    func widgetDidEndEditing() {
        // The user has clicked the Done button, begun editing another widget,
        // or the Notification Center has been closed.
        // Take the list view out of editing mode.
        self.listViewController.editing = false
    }
    
    // MARK: - NCWidgetListViewDelegate
    
    func widgetList(_ list: NCWidgetListViewController, viewControllerForRow row: Int) -> NSViewController {
        // Return a new view controller subclass for displaying an item of widget
        // content. The NCWidgetListViewController will set the representedObject
        // of this view controller to one of the objects in its contents array.
        self.departureRowViewController = DepartureRowViewController();
        self.departureRowViewController?.departure = self.listViewController.contents[row] as? Departure;
        return departureRowViewController!;
    }
    
    func widgetListPerformAddAction(_ list: NCWidgetListViewController) {
    }
    
    func widgetList(_ list: NCWidgetListViewController, shouldReorderRow row: Int) -> Bool {
        // Return true to allow the item to be reordered in the list by the user.
        return true
    }
    
    func widgetList(_ list: NCWidgetListViewController, didReorderRow row: Int, toRow newIndex: Int) {
        // The user has reordered an item in the list.
    }
    
    func widgetList(_ list: NCWidgetListViewController, shouldRemoveRow row: Int) -> Bool {
        // Return true to allow the item to be removed from the list by the user.
        return true
    }
    
    func widgetList(_ list: NCWidgetListViewController, didRemoveRow row: Int) {
        // The user has removed an item from the list.
    }
}
