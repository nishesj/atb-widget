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

class TodayViewController: NSViewController, NCWidgetProviding, NCWidgetListViewDelegate, NCWidgetSearchViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var listViewController: NCWidgetListViewController!
    var searchController: NCWidgetSearchViewController?
    
    var listRowViewController: ListRowViewController?
    
    var locationManager:CLLocationManager!
    
    
    // MARK: - NSViewController
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("TodayViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
        
        // Set up the widget list view controller.
        // The contents property should contain an object for each row in the list.
        self.listViewController.contents = []
    }
    
    override func dismissViewController(_ viewController: NSViewController) {
        super.dismissViewController(viewController)
        
        // The search controller has been dismissed and is no longer needed.
        if viewController == self.searchController {
            self.searchController = nil
        }
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
        return true
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
        self.listRowViewController = ListRowViewController();
        self.listRowViewController?.departure = self.listViewController.contents[row] as? Departure;
        return listRowViewController!;
    }
    
    func widgetListPerformAddAction(_ list: NCWidgetListViewController) {
        // The user has clicked the add button in the list view.
        // Display a search controller for adding new content to the widget.
        let searchController = NCWidgetSearchViewController()
        self.searchController = searchController
        searchController.delegate = self
        
        // Present the search view controller with an animation.
        // Implement dismissViewController to observe when the view controller
        // has been dismissed and is no longer needed.
        self.present(inWidget: searchController)
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
    
    // MARK: - NCWidgetSearchViewDelegate
    
    func widgetSearch(_ searchController: NCWidgetSearchViewController, searchForTerm searchTerm: String, maxResults max: Int) {
        // The user has entered a search term. Set the controller's searchResults property to the matching items.
        searchController.searchResults = []
    }
    
    func widgetSearchTermCleared(_ searchController: NCWidgetSearchViewController) {
        // The user has cleared the search field. Remove the search results.
        searchController.searchResults = nil
    }
    
    func widgetSearch(_ searchController: NCWidgetSearchViewController, resultSelected object: Any) {
        // The user has selected a search result from the list.
    }
    
    // MARK: - Location Code
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        print(center)
        self.locationManager.stopUpdatingLocation()
        
        getBusStops() { (result) in
            switch result {
            case .success(let stops):
                var closestBusStop = self.nearestBusStop(stops: stops, currentLocation: location)
                getBusDeparture(for: closestBusStop!) { (result) in
                    switch result {
                    case .success(let departuresResponse):
                        print(departuresResponse)
                        self.listViewController.contents = departuresResponse.departures
                        
                    case .failure(let error):
                        fatalError("error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                fatalError("error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func nearestBusStop(stops: [BusStop],  currentLocation: CLLocation) -> BusStop? {
        if stops.count == 0 {
            return nil
        }
        
        var closestLocation: BusStop?
        var smallestDistance: CLLocationDistance?
        
        for stop in stops {
            let location = CLLocation.init(latitude: stop.latitude, longitude: stop.longitude)
            let distance = currentLocation.distance(from: location)
            if smallestDistance == nil || distance < smallestDistance! {
                closestLocation = stop
                smallestDistance = distance
            }
        }
        return closestLocation
    }
}
